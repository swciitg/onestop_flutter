package com.swciitg.onestop2

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.EditText
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.core.app.NotificationCompat
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.qrcode.QRCodeWriter
import okhttp3.*
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

class GateLogOverlayService : Service() {

    companion object {
        const val CHANNEL_ID = "gatelog_overlay"
        const val NOTIFICATION_ID = 9001
        const val EXTRA_DESTINATION = "destination"
        const val EXTRA_AUTO_CHECKIN = "autoCheckIn"
    }

    private lateinit var windowManager: WindowManager
    private var overlayView: View? = null
    private var webSocket: WebSocket? = null
    private val handler = Handler(Looper.getMainLooper())
    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(0, TimeUnit.MINUTES) // no read timeout for WSS
        .build()

    // Flow data
    private var destination: String? = null
    private var autoCheckIn = false
    private var connectionId: String? = null
    private var authToken: String? = null
    private var hasTriedRefresh = false

    // Views
    private var qrImageView: ImageView? = null
    private var statusText: TextView? = null
    private var destinationText: TextView? = null
    private var closeButton: View? = null
    private var progressBar: ProgressBar? = null
    private var destinationInput: EditText? = null
    private var submitButton: View? = null
    private var successIcon: TextView? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Clean up any previous overlay
        cleanupOverlay()

        destination = intent?.getStringExtra(EXTRA_DESTINATION)
        autoCheckIn = intent?.getBooleanExtra(EXTRA_AUTO_CHECKIN, false) ?: false
        hasTriedRefresh = false

        // Read auth token from Flutter SharedPreferences
        val flutterPrefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        authToken = flutterPrefs.getString("flutter.accessToken", null)

        if (authToken.isNullOrBlank() || authToken == " ") {
            Toast.makeText(this, "Please login to OneStop first", Toast.LENGTH_LONG).show()
            stopSelf()
            return START_NOT_STICKY
        }

        startForeground(NOTIFICATION_ID, buildNotification())
        showOverlay()

        if (destination == "Others") {
            showDestinationInput()
        } else {
            startFlow()
        }

        return START_NOT_STICKY
    }

    // ─── Overlay UI ──────────────────────────────────────────────

    private fun showOverlay() {
        val inflater = LayoutInflater.from(this)
        overlayView = inflater.inflate(R.layout.gatelog_overlay, null)

        qrImageView = overlayView!!.findViewById(R.id.overlayQrImage)
        statusText = overlayView!!.findViewById(R.id.overlayStatusText)
        destinationText = overlayView!!.findViewById(R.id.overlayDestination)
        closeButton = overlayView!!.findViewById(R.id.overlayCloseBtn)
        progressBar = overlayView!!.findViewById(R.id.overlayProgress)
        destinationInput = overlayView!!.findViewById(R.id.overlayDestinationInput)
        submitButton = overlayView!!.findViewById(R.id.overlaySubmitBtn)
        successIcon = overlayView!!.findViewById(R.id.overlaySuccessIcon)

        closeButton?.setOnClickListener { cleanup() }
        overlayView!!.findViewById<View>(R.id.overlayScrim).setOnClickListener { cleanup() }
        // Consume card clicks so scrim handler doesn't fire
        overlayView!!.findViewById<View>(R.id.overlayCard).setOnClickListener { }

        submitButton?.setOnClickListener {
            val custom = destinationInput?.text?.toString()?.trim()
            if (!custom.isNullOrEmpty()) {
                destination = custom
                destinationInput?.visibility = View.GONE
                submitButton?.visibility = View.GONE
                startFlow()
            }
        }

        // Set destination label
        when {
            !autoCheckIn && destination != "Others" && destination != null -> {
                destinationText?.text = "To $destination"
                destinationText?.visibility = View.VISIBLE
            }
            autoCheckIn -> {
                destinationText?.text = "Check into Campus"
                destinationText?.visibility = View.VISIBLE
            }
        }

        val layoutFlag = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY

        // Get the full screen size including status & navigation bars
        val realSize = android.graphics.Point()
        windowManager.defaultDisplay.getRealSize(realSize)

        val params = WindowManager.LayoutParams(
            realSize.x,
            realSize.y,
            layoutFlag,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 0
            y = 0
            screenBrightness = 1.0f
        }

        windowManager.addView(overlayView, params)
    }

    private fun showDestinationInput() {
        destinationInput?.visibility = View.VISIBLE
        submitButton?.visibility = View.VISIBLE
        progressBar?.visibility = View.GONE
        statusText?.text = "Enter your destination"
    }

    private fun updateUI(
        showQr: Boolean = false,
        showProgress: Boolean = false,
        showSuccess: Boolean = false,
        status: String = "",
        statusColor: Int = Color.parseColor("#9B9B9B"),
    ) {
        qrImageView?.visibility = if (showQr) View.VISIBLE else View.GONE
        progressBar?.visibility = if (showProgress) View.VISIBLE else View.GONE
        successIcon?.visibility = if (showSuccess) View.VISIBLE else View.GONE
        statusText?.text = status
        statusText?.setTextColor(statusColor)
    }

    // ─── Flow logic ──────────────────────────────────────────────

    private fun startFlow() {
        updateUI(showProgress = true, status = "Connecting...")
        if (autoCheckIn) {
            fetchLatestEntry()
        } else {
            fetchUserIdAndConnect()
        }
    }

    /**
     * Attempts to refresh the access token using the stored refresh token.
     * On success, updates both the in-memory [authToken] and SharedPreferences,
     * then invokes [onSuccess]. On failure, shows an error in the overlay.
     */
    private fun refreshAccessToken(onSuccess: () -> Unit) {
        val serverUrl = BuildConfig.SERVER_URL
        val securityKey = BuildConfig.SECURITY_KEY
        val flutterPrefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val refreshToken = flutterPrefs.getString("flutter.refreshToken", null)

        if (refreshToken.isNullOrBlank()) {
            handler.post {
                updateUI(status = "Session expired. Please login to OneStop.",
                    statusColor = Color.parseColor("#FF4444"))
            }
            return
        }

        val request = Request.Builder()
            .url("$serverUrl/user/accesstoken")
            .addHeader("Security-Key", securityKey)
            .addHeader("authorization", "Bearer $refreshToken")
            .post(RequestBody.create(null, ByteArray(0)))
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                handler.post {
                    updateUI(status = "Session expired. Please login to OneStop.",
                        statusColor = Color.parseColor("#FF4444"))
                }
            }

            override fun onResponse(call: Call, response: Response) {
                response.use { resp ->
                    if (!resp.isSuccessful) {
                        handler.post {
                            updateUI(status = "Session expired. Please login to OneStop.",
                                statusColor = Color.parseColor("#FF4444"))
                        }
                        return
                    }
                    try {
                        val json = JSONObject(resp.body!!.string())
                        val newToken = json.getString("accessToken")
                        authToken = newToken
                        flutterPrefs.edit().putString("flutter.accessToken", newToken).apply()
                        handler.post { onSuccess() }
                    } catch (e: Exception) {
                        handler.post {
                            updateUI(status = "Session expired. Please login to OneStop.",
                                statusColor = Color.parseColor("#FF4444"))
                        }
                    }
                }
            }
        })
    }

    private fun fetchUserIdAndConnect() {
        val serverUrl = BuildConfig.SERVER_URL
        val securityKey = BuildConfig.SECURITY_KEY

        val request = Request.Builder()
            .url("$serverUrl/user/getUserid")
            .addHeader("Content-Type", "application/json")
            .addHeader("security-key", securityKey)
            .addHeader("Authorization", "Bearer $authToken")
            .get()
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                handler.post {
                    updateUI(status = "Network error: ${e.localizedMessage}",
                        statusColor = Color.parseColor("#FF4444"))
                }
            }

            override fun onResponse(call: Call, response: Response) {
                response.use { resp ->
                    if (!resp.isSuccessful) {
                        if (resp.code == 401 && !hasTriedRefresh) {
                            hasTriedRefresh = true
                            handler.post {
                                updateUI(showProgress = true, status = "Refreshing session...")
                                refreshAccessToken { fetchUserIdAndConnect() }
                            }
                            return
                        }
                        handler.post {
                            updateUI(status = "Failed to get user info (${resp.code})",
                                statusColor = Color.parseColor("#FF4444"))
                        }
                        return
                    }
                    try {
                        val json = JSONObject(resp.body!!.string())
                        val userId = json.getString("userId")
                        handler.post { connectWebSocket(userId = userId) }
                    } catch (e: Exception) {
                        handler.post {
                            updateUI(status = "Parse error: ${e.localizedMessage}",
                                statusColor = Color.parseColor("#FF4444"))
                        }
                    }
                }
            }
        })
    }

    private fun fetchLatestEntry() {
        val gatelogUrl = BuildConfig.GATELOG_SERVER_URL
        val securityKey = BuildConfig.SECURITY_KEY

        val request = Request.Builder()
            .url("$gatelogUrl/history?page=1&size=1")
            .addHeader("Content-Type", "application/json")
            .addHeader("security-key", securityKey)
            .addHeader("Authorization", "Bearer $authToken")
            .get()
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                handler.post {
                    updateUI(status = "Network error: ${e.localizedMessage}",
                        statusColor = Color.parseColor("#FF4444"))
                }
            }

            override fun onResponse(call: Call, response: Response) {
                response.use { resp ->
                    if (!resp.isSuccessful) {
                        if (resp.code == 401 && !hasTriedRefresh) {
                            hasTriedRefresh = true
                            handler.post {
                                updateUI(showProgress = true, status = "Refreshing session...")
                                refreshAccessToken { fetchLatestEntry() }
                            }
                            return
                        }
                        handler.post {
                            updateUI(status = "Failed to fetch entry (${resp.code})",
                                statusColor = Color.parseColor("#FF4444"))
                        }
                        return
                    }
                    try {
                        val json = JSONObject(resp.body!!.string())
                        val history = json.getJSONArray("history")
                        if (history.length() > 0) {
                            val entry = history.getJSONObject(0)
                            val isClosed = entry.getBoolean("isClosed")
                            if (!isClosed) {
                                val entryId = entry.getString("_id")
                                handler.post { connectWebSocket(entryId = entryId) }
                            } else {
                                handler.post {
                                    updateUI(status = "No open entry to check in",
                                        statusColor = Color.parseColor("#FF4444"))
                                }
                            }
                        } else {
                            handler.post {
                                updateUI(status = "No entries found",
                                    statusColor = Color.parseColor("#FF4444"))
                            }
                        }
                    } catch (e: Exception) {
                        handler.post {
                            updateUI(status = "Parse error: ${e.localizedMessage}",
                                statusColor = Color.parseColor("#FF4444"))
                        }
                    }
                }
            }
        })
    }

    // ─── WebSocket ───────────────────────────────────────────────

    private fun connectWebSocket(userId: String? = null, entryId: String? = null) {
        val wssUrl = BuildConfig.GATELOG_WSS_URL
        val securityKey = BuildConfig.SECURITY_KEY

        if (wssUrl.isBlank()) {
            updateUI(status = "WebSocket URL not configured", statusColor = Color.parseColor("#FF4444"))
            return
        }

        val request = Request.Builder()
            .url(wssUrl)
            .addHeader("Content-Type", "application/json")
            .addHeader("security-key", securityKey)
            .addHeader("Authorization", "Bearer $authToken")
            .build()

        webSocket?.close(1000, "Reconnecting")
        webSocket = client.newWebSocket(request, object : WebSocketListener() {

            override fun onOpen(webSocket: WebSocket, response: Response) {
                handler.post {
                    updateUI(showProgress = true, status = "Connected, waiting...")
                }
            }

            override fun onMessage(webSocket: WebSocket, text: String) {
                try {
                    val json = JSONObject(text)
                    val event = json.optString("eventName", "")
                    handler.post { handleSocketEvent(event, json, userId, entryId) }
                } catch (_: Exception) {}
            }

            override fun onFailure(webSocket: WebSocket, t: Throwable, response: Response?) {
                handler.post {
                    updateUI(status = "Connection failed: ${t.localizedMessage}",
                        statusColor = Color.parseColor("#FF4444"))
                }
            }

            override fun onClosed(webSocket: WebSocket, code: Int, reason: String) {
                // No-op unless unexpected
            }
        })
    }

    private fun handleSocketEvent(
        event: String,
        json: JSONObject,
        userId: String?,
        entryId: String?
    ) {
        when (event) {
            "CONNECTION" -> {
                connectionId = json.getString("connectionId")
                val isCheckout = entryId == null
                val qrPayload = if (!isCheckout) {
                    // Check-in QR
                    JSONObject().apply {
                        put("connectionId", connectionId)
                        put("entryId", entryId)
                        put("isExit", false)
                    }
                } else {
                    // Check-out QR
                    JSONObject().apply {
                        put("destination", destination)
                        put("connectionId", connectionId)
                        put("userId", userId)
                        put("isExit", true)
                    }
                }
                showQrCode(qrPayload.toString())
            }

            "REQUEST_RECEIVED" -> {
                updateUI(showProgress = true, status = "QR scanned, processing...")
            }

            "TIMEOUT" -> {
                updateUI(showProgress = true, status = "Timed out, reconnecting...")
                webSocket?.close(1000, "Timeout")
                connectWebSocket(userId = userId, entryId = entryId)
            }

            "ENTRY_ADDED" -> {
                updateUI(showSuccess = true,
                    status = "Checked out successfully!",
                    statusColor = Color.parseColor("#14BD56"))
                syncWidgetState(isCheckedOut = true)
                handler.postDelayed({ cleanup() }, 2500)
            }

            "ENTRY_CLOSED" -> {
                updateUI(showSuccess = true,
                    status = "Checked in successfully!",
                    statusColor = Color.parseColor("#14BD56"))
                syncWidgetState(isCheckedOut = false)
                handler.postDelayed({ cleanup() }, 2500)
            }

            "ERROR" -> {
                val msg = json.optString("message", "An error occurred")
                updateUI(status = msg, statusColor = Color.parseColor("#FF4444"))
            }
        }
    }

    // ─── QR code generation ──────────────────────────────────────

    private fun showQrCode(data: String) {
        try {
            val size = 800
            val hints = mapOf(
                EncodeHintType.MARGIN to 1,
                EncodeHintType.CHARACTER_SET to "UTF-8"
            )
            val bitMatrix = QRCodeWriter().encode(
                data, BarcodeFormat.QR_CODE, size, size, hints
            )
            val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
            for (x in 0 until size) {
                for (y in 0 until size) {
                    bitmap.setPixel(x, y, if (bitMatrix[x, y]) Color.BLACK else Color.WHITE)
                }
            }
            qrImageView?.setImageBitmap(bitmap)
            updateUI(showQr = true, status = "Scan this QR at the gate")
        } catch (e: Exception) {
            updateUI(status = "QR generation failed: ${e.localizedMessage}",
                statusColor = Color.parseColor("#FF4444"))
        }
    }

    // ─── Widget state sync ───────────────────────────────────────

    private fun syncWidgetState(isCheckedOut: Boolean) {
        try {
            val prefs = getSharedPreferences("HomeWidgetPreferences", MODE_PRIVATE)
            prefs.edit().apply {
                putBoolean("gl_is_checked_out", isCheckedOut)
                putString("gl_destination", if (isCheckedOut) destination ?: "" else "")
                apply()
            }

            // Trigger widget refresh
            val widgetManager = AppWidgetManager.getInstance(this)
            val ids = widgetManager.getAppWidgetIds(
                ComponentName(this, GateLogHomeWidgetProvider::class.java)
            )
            if (ids.isNotEmpty()) {
                val updateIntent = Intent(this, GateLogHomeWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                }
                sendBroadcast(updateIntent)
            }
        } catch (_: Exception) {}
    }

    // ─── Notification ────────────────────────────────────────────

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID, "Gatelog", NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Active while gatelog overlay is visible"
            }
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Gatelog")
            .setContentText("Gate log in progress...")
            .setSmallIcon(R.drawable.ic_stat_notification_icon)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .build()
    }

    // ─── Cleanup ─────────────────────────────────────────────────

    private fun cleanupOverlay() {
        webSocket?.close(1000, "Dismissed")
        webSocket = null
        overlayView?.let {
            try { windowManager.removeView(it) } catch (_: Exception) {}
        }
        overlayView = null
    }

    private fun cleanup() {
        cleanupOverlay()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    override fun onDestroy() {
        cleanupOverlay()
        super.onDestroy()
    }
}
