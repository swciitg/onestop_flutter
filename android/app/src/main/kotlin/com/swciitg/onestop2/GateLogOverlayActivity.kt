package com.swciitg.onestop2

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast

/**
 * Transparent trampoline activity that checks SYSTEM_ALERT_WINDOW permission
 * and starts GateLogOverlayService. Launched from the gatelog home-screen widget.
 */
class GateLogOverlayActivity : Activity() {

    companion object {
        private const val REQUEST_OVERLAY_PERMISSION = 1001
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Settings.canDrawOverlays(this)) {
            startOverlayService()
            finish()
        } else {
            // Redirect to system overlay permission settings
            val permIntent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            @Suppress("DEPRECATION")
            startActivityForResult(permIntent, REQUEST_OVERLAY_PERMISSION)
        }
    }

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_OVERLAY_PERMISSION) {
            if (Settings.canDrawOverlays(this)) {
                startOverlayService()
            } else {
                Toast.makeText(
                    this,
                    "Overlay permission is required for Gatelog quick-action",
                    Toast.LENGTH_LONG
                ).show()
            }
        }
        finish()
    }

    private fun startOverlayService() {
        val serviceIntent = Intent(this, GateLogOverlayService::class.java).apply {
            putExtra(
                GateLogOverlayService.EXTRA_DESTINATION,
                intent.getStringExtra("destination")
            )
            putExtra(
                GateLogOverlayService.EXTRA_AUTO_CHECKIN,
                intent.getBooleanExtra("autoCheckIn", false)
            )
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }
}
