package com.swciitg.onestop2

import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SCREENSHOT_CHANNEL = "com.example.app/screenshot"

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
    }

    private fun preventScreenshots(prevent: Boolean) {
        if (prevent) {
            window.addFlags(LayoutParams.FLAG_SECURE)
        } else {
            window.clearFlags(LayoutParams.FLAG_SECURE)
        }
    }
}
