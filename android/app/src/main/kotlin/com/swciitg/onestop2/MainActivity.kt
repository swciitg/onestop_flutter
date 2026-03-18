package com.swciitg.onestop2

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Process
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SCREENSHOT_CHANNEL = "com.example.app/screenshot"
    private val RESTART_CHANNEL = "com.swciitg.onestop2/restart"
    private val ICON_CHANNEL = "com.swciitg.onestop2/app_icon"

    // Activity-alias names defined in AndroidManifest.xml
    private val iconAliases = listOf("dark", "light")

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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ICON_CHANNEL)
                .setMethodCallHandler { call, result ->
                    if (call.method == "setAlternateIcon") {
                        val iconName = call.arguments as? String
                        if (iconName != null) {
                            setAlternateIcon(iconName)
                            result.success(null)
                        } else {
                            result.error("INVALID_ARG", "iconName is required", null)
                        }
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

    private fun setAlternateIcon(iconName: String) {
        val pm = packageManager
        val packageName = componentName.packageName

        // Disable all alternate icon aliases
        for (alias in iconAliases) {
            val comp = ComponentName(packageName, "$packageName.MainActivity.$alias")
            pm.setComponentEnabledSetting(
                comp,
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }

        // Disable the default MainActivity launcher
        pm.setComponentEnabledSetting(
            ComponentName(packageName, "$packageName.MainActivity"),
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )

        // Enable the requested alias
        val targetComp = ComponentName(packageName, "$packageName.MainActivity.$iconName")
        pm.setComponentEnabledSetting(
            targetComp,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
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
