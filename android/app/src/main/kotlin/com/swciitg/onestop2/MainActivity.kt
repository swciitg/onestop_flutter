package com.swciitg.onestop2

import android.content.Intent
import android.os.Process
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SCREENSHOT_CHANNEL = "com.example.app/screenshot"
    private val RESTART_CHANNEL = "com.swciitg.onestop2/restart"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCREENSHOT_CHANNEL)
                .setMethodCallHandler { call, result ->
                    if (call.method == "preventScreenshots") {
                        preventScreenshots(call.arguments as Boolean)
                        result.success(null)
                    } else {
                        result.notImplemented()
                    }
                }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RESTART_CHANNEL)
                .setMethodCallHandler { call, result ->
                    if (call.method == "restartApp") {
                        result.success(true)
                        restartApp()
                    } else {
                        result.notImplemented()
                    }
                }
    }

    private fun preventScreenshots(prevent: Boolean) {
        if (prevent) {
            window.addFlags(LayoutParams.FLAG_SECURE)
        } else {
            window.clearFlags(LayoutParams.FLAG_SECURE)
        }
    }

    private fun restartApp() {
        // Launch the trampoline activity in a separate process (":restart").
        // It will kill the main process and then relaunch the main activity.
        val intent = Intent(this, RestartActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            putExtra(RestartActivity.KEY_MAIN_PID, Process.myPid())
        }
        startActivity(intent)
    }
}
