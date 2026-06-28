package com.swciitg.onestop2

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class GateLogHomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val views = RemoteViews(context.packageName, R.layout.gatelog_home_widget)

            val isCheckedOut = widgetData.getBoolean("gl_is_checked_out", false)
            val isDark = widgetData.getBoolean("gl_is_dark", false)

            applyTheme(views, isDark, isCheckedOut)

            if (isCheckedOut) {
                // Checked-out state: show check-in section
                views.setViewVisibility(R.id.glDefaultSection, View.GONE)
                views.setViewVisibility(R.id.glCheckedOutSection, View.VISIBLE)

                // Gate closing info
                val gateInfo = computeGateClosingInfo()
                if (gateInfo.isNotBlank()) {
                    views.setTextViewText(R.id.glGateInfo, gateInfo)
                    views.setViewVisibility(R.id.glGateInfo, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.glGateInfo, View.GONE)
                }

                // Check-in button → overlay with autoCheckIn
                setupOverlayIntent(context, views, R.id.glBtnCheckIn,
                    destination = null, autoCheckIn = true, requestCode = appWidgetId * 10 + 4)

                // Whole widget taps to full app
                setupDeepLinkIntent(context, views, R.id.glWidgetRoot,
                    "onestopiitg://gatelog", appWidgetId * 10 + 5)
            } else {
                // Default state: show 3 destination buttons → overlay
                views.setViewVisibility(R.id.glDefaultSection, View.VISIBLE)
                views.setViewVisibility(R.id.glCheckedOutSection, View.GONE)

                setupOverlayIntent(context, views, R.id.glBtnCity,
                    destination = "City", requestCode = appWidgetId * 10 + 1)
                setupOverlayIntent(context, views, R.id.glBtnKhokha,
                    destination = "Khokha", requestCode = appWidgetId * 10 + 2)
                setupOverlayIntent(context, views, R.id.glBtnOthers,
                    destination = "Others", requestCode = appWidgetId * 10 + 3)

                // Widget root taps to full app
                setupDeepLinkIntent(context, views, R.id.glWidgetRoot,
                    "onestopiitg://gatelog", appWidgetId * 10)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun computeGateClosingInfo(): String {
        val now = java.util.Calendar.getInstance()
        val hour = now.get(java.util.Calendar.HOUR_OF_DAY)
        val minute = now.get(java.util.Calendar.MINUTE)
        val totalMinutes = hour * 60 + minute

        val khokhaClose = 22 * 60  // 10:00 PM
        val kvClose = 22 * 60 + 30 // 10:30 PM

        val khokhaLeft = khokhaClose - totalMinutes
        val kvLeft = kvClose - totalMinutes

        return when {
            khokhaLeft > 0 -> "KHOKHA CLOSES IN ${formatRemaining(khokhaLeft)}"
            kvLeft > 0 -> "KV GATE CLOSES IN ${formatRemaining(kvLeft)}"
            else -> "ENTER VIA MAIN GATE"
        }
    }

    private fun formatRemaining(totalMinutes: Int): String {
        val hours = totalMinutes / 60
        val mins = totalMinutes % 60
        return when {
            hours > 0 && mins > 0 -> "$hours ${if (hours == 1) "HR" else "HRS"} $mins ${if (mins == 1) "MIN" else "MINS"}"
            hours > 0 -> "$hours ${if (hours == 1) "HR" else "HRS"}"
            mins > 0 -> "$mins ${if (mins == 1) "MIN" else "MINS"}"
            else -> ""
        }
    }

    private fun applyTheme(views: RemoteViews, isDark: Boolean, isCheckedOut: Boolean) {
        val bg = if (isDark) R.drawable.gatelog_widget_background_dark
            else R.drawable.gatelog_widget_background_light
        views.setInt(R.id.glWidgetRoot, "setBackgroundResource", bg)

        val btnOutline = if (isDark) R.drawable.gatelog_widget_button_outline_dark
            else R.drawable.gatelog_widget_button_outline_light
        views.setInt(R.id.glBtnCity, "setBackgroundResource", btnOutline)
        views.setInt(R.id.glBtnKhokha, "setBackgroundResource", btnOutline)
        views.setInt(R.id.glBtnOthers, "setBackgroundResource", btnOutline)
        views.setInt(R.id.glBtnCheckIn, "setBackgroundResource", btnOutline)

        val titleColor = if (isDark) 0xFFFDFDFC.toInt() else 0xFF000000.toInt()
        val greenColor = if (isDark) 0xFF14BD56.toInt() else 0xFF1AB056.toInt()  // green500
        val gray600 = if (isDark) 0xFF9B9B9B.toInt() else 0xFF6E6F77.toInt()
        val gray500 = if (isDark) 0xFF6F6F6F.toInt() else 0xFF98999F.toInt()

        // Title color: green when checked out, black otherwise
        views.setTextColor(R.id.glTitle, if (isCheckedOut) greenColor else titleColor)

        // Buttons
        views.setTextColor(R.id.glBtnCity, greenColor)
        views.setTextColor(R.id.glBtnKhokha, greenColor)
        views.setTextColor(R.id.glBtnOthers, greenColor)
        views.setTextColor(R.id.glBtnCheckIn, greenColor)

        // Checked-out section
        views.setTextColor(R.id.glCheckInLabel, gray600)
        views.setTextColor(R.id.glGateInfo, gray500)
    }

    /** Launch the overlay activity for quick gatelog action */
    private fun setupOverlayIntent(
        context: Context,
        views: RemoteViews,
        viewId: Int,
        destination: String? = null,
        autoCheckIn: Boolean = false,
        requestCode: Int,
    ) {
        val intent = Intent(context, GateLogOverlayActivity::class.java).apply {
            destination?.let { putExtra("destination", it) }
            putExtra("autoCheckIn", autoCheckIn)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingIntent = PendingIntent.getActivity(context, requestCode, intent, flags)
        views.setOnClickPendingIntent(viewId, pendingIntent)
    }

    /** Deep-link into the full Flutter app (for widget root tap) */
    private fun setupDeepLinkIntent(
        context: Context,
        views: RemoteViews,
        viewId: Int,
        deepLink: String,
        requestCode: Int,
    ) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(deepLink)).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingIntent = PendingIntent.getActivity(context, requestCode, intent, flags)
        views.setOnClickPendingIntent(viewId, pendingIntent)
    }
}
