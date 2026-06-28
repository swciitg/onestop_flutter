package com.swciitg.onestop2

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Process

/**
 * Lightweight trampoline activity that runs in a SEPARATE process (":restart").
 * It survives the main-process death, relaunches the main activity, then exits.
 */
class RestartActivity : Activity() {

    companion object {
        const val KEY_MAIN_PID = "main_pid"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Kill the main process (sent via intent extra)
        val mainPid = intent.getIntExtra(KEY_MAIN_PID, -1)
        if (mainPid > 0) {
            Process.killProcess(mainPid)
        }

        // Relaunch the main activity
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        if (launchIntent != null) {
            launchIntent.addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            )
            startActivity(launchIntent)
        }

        // Close this trampoline
        finish()

        // Exit the ":restart" process
        Runtime.getRuntime().exit(0)
    }
}
