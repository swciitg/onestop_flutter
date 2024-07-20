package com.swciitg.onestop2

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.KeyData.CHANNEL
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME = ""
    private var methodChannel: MethodChannel? =null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"com.swciitg.onestop2/sendRollnumber")
        methodChannel!!.setMethodCallHandler{
                call,result ->
            if (call.method == "sendRollNumber") {
//                val rollNumber = call.argument<String>("rollNumber")
                val rollNumber="210108009"
                if (rollNumber != null) {
                    Log.d("inside ------------------ ",rollNumber)
                    updateWidget(rollNumber)
                }else{
                    Log.d("inside","no roll found")
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
    private fun updateWidget(rollNumber: String) {
        // Save roll number in SharedPreferences or another persistent storage
        getSharedPreferences("com.swciitg.onestop2", Context.MODE_PRIVATE)
            .edit()
            .putString("roll_number", rollNumber)
            .apply()
        // Trigger widget update
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val widgetComponent = ComponentName(this, TimeTableWidget::class.java)
        val widgetIds = appWidgetManager.getAppWidgetIds(widgetComponent)
        for(id in widgetIds){
            GlobalScope.launch {
                performApiCall(context,appWidgetManager, id)
            }
        }
        appWidgetManager.notifyAppWidgetViewDataChanged(widgetIds, R.layout.time_table_widget)
    }
}
