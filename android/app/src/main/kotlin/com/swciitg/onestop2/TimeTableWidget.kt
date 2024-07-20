package com.swciitg.onestop2

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import com.google.gson.Gson
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.logging.HttpLoggingInterceptor
import org.json.JSONObject
import java.io.IOException
import java.util.Calendar

/**
 * Implementation of App Widget functionality.
 */
class TimeTableWidget : AppWidgetProvider() {
    @OptIn(DelicateCoroutinesApi::class)
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
//            val workRequest = OneTimeWorkRequestBuilder<NetworkWorker>()
//                .build()
//            WorkManager.getInstance(context).enqueue(workRequest)
            GlobalScope.launch {
                performApiCall(context,appWidgetManager,appWidgetId)
                updateAppWidget(context, appWidgetManager, appWidgetId)
                scheduleDailyWidgetUpdate(context)
            }

        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val sharedPrefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
    var timetableData = sharedPrefs.getString("timetable_data", "[]") ?: "[]"
    if(timetableData=="[]"){
        GlobalScope.launch {
            performApiCall(context,appWidgetManager,appWidgetId)
            timetableData = sharedPrefs.getString("timetable_data", "[]") ?: "[]"
            val intent = Intent(context, TimeTableService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                putExtra("timetable_data_key",timetableData)
            }
            val views = RemoteViews(context.packageName, R.layout.time_table_widget).apply {
                setRemoteAdapter(R.id.timetable_list, intent)
                setEmptyView(R.id.timetable_list, android.R.id.empty)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }else{
        val intent = Intent(context, TimeTableService::class.java).apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("timetable_data_key",timetableData)
        }
        val views = RemoteViews(context.packageName, R.layout.time_table_widget).apply {
            setRemoteAdapter(R.id.timetable_list, intent)
            setEmptyView(R.id.timetable_list, android.R.id.empty)
        }
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

}
private fun scheduleDailyWidgetUpdate(context: Context) {
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val dailyIntent = Intent(context, WidgetUpdateReceiver::class.java).apply {
        action = "com.example.UPDATE_DAILY"
    }
    val dailyPendingIntent = PendingIntent.getBroadcast(context, 0, dailyIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

    val threeHourIntent = Intent(context, WidgetUpdateReceiver::class.java).apply {
        action = "com.example.UPDATE_EVERY_3_HOURS"
    }
    val threeHourPendingIntent = PendingIntent.getBroadcast(context, 1, threeHourIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

    val calendar = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 0) // Set the hour to 12 AM
        set(Calendar.MINUTE, 6)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
    }

    if (calendar.timeInMillis < System.currentTimeMillis()) {
        calendar.add(Calendar.DAY_OF_MONTH, 1)
    }

    // Schedule daily update
    alarmManager.setRepeating(
        AlarmManager.RTC_WAKEUP,
        calendar.timeInMillis,
        AlarmManager.INTERVAL_DAY,
        dailyPendingIntent
    )

    // Schedule update every 3 hours
    alarmManager.setRepeating(
        AlarmManager.RTC_WAKEUP,
        System.currentTimeMillis(), // Start immediately
        AlarmManager.INTERVAL_HOUR ,
        threeHourPendingIntent
    )

    // Trigger immediate update
    val appWidgetManager = AppWidgetManager.getInstance(context)
    val componentName = ComponentName(context, TimeTableWidget::class.java)
    val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
    for (appWidgetId in appWidgetIds) {
        updateAppWidget(context, appWidgetManager, appWidgetId)
    }
}
suspend fun performApiCall(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    // Set up logging interceptor
    Log.d("inside","hehe u idiot line 168 fucked up")
    val logging = HttpLoggingInterceptor().apply {
        level = HttpLoggingInterceptor.Level.BODY
    }

    // Build OkHttpClient with logging interceptor
    val client = OkHttpClient.Builder()
        .addInterceptor(logging)
        .build()
    val sharedPreference = context.getSharedPreferences("com.swciitg.onestop2",Context.MODE_PRIVATE)
    val currentRoll = sharedPreference.getString("roll_number","210104021")
    // Create JSON payload
    val json = JSONObject().apply {
        put("roll_number", currentRoll)
    }

    // Create request body
    val requestBody = json.toString().toRequestBody("application/json; charset=utf-8".toMediaTypeOrNull())

    // Build request
    val request = Request.Builder()
        .url("https://swc.iitg.ac.in/smartTimetable/get-my-courses")
        .post(requestBody)
        .build()

    // Execute the API request
    withContext(Dispatchers.IO) {
        try {
            val response = client.newCall(request).execute()
            if (response.isSuccessful) {
                val responseBody = response.body?.string()
                if (responseBody != null) {
                    val gson = Gson()
                    val timetableResponse: TimeTableResponse = gson.fromJson(responseBody, TimeTableResponse::class.java)

                    // Save data to SharedPreferences
                    val sharedPrefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
                    sharedPrefs.edit().putString("timetable_data", responseBody).apply()
                    Log.d("inside line 206",responseBody)
                    Log.d("inside line 97","hi")
                    // Update the widget
                    updateAppWidget(context, appWidgetManager, appWidgetId)
                }
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }
}
// Create a list of maps to store timetable items
//fun performApiCall(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
//    // Set up logging interceptor
//    Log.d("inside","hehe u idiot line 168 fucked up")
//    val logging = HttpLoggingInterceptor().apply {
//        level = HttpLoggingInterceptor.Level.BODY
//    }
//
//    // Build OkHttpClient with logging interceptor
//    val client = OkHttpClient.Builder()
//        .addInterceptor(logging)
//        .build()
//    val sharedPreference = context.getSharedPreferences("com.swciitg.onestop2",Context.MODE_PRIVATE)
//    val currentRoll = sharedPreference.getString("roll_number","210104021")
//    // Create JSON payload
//    val json = JSONObject().apply {
//        put("roll_number", currentRoll)
//    }
//
//    // Create request body
//    val requestBody = json.toString().toRequestBody("application/json; charset=utf-8".toMediaTypeOrNull())
//
//    // Build request
//    val request = Request.Builder()
//        .url("https://swc.iitg.ac.in/smartTimetable/get-my-courses")
//        .post(requestBody)
//        .build()
//
//    // Execute the API request
//    Thread {
//        try {
//            val response = client.newCall(request).execute()
//            if (response.isSuccessful) {
//                val responseBody = response.body?.string()
//                if (responseBody != null) {
//                    val gson = Gson()
//                    val timetableResponse: TimeTableResponse = gson.fromJson(responseBody, TimeTableResponse::class.java)
//
//                    // Save data to SharedPreferences
//                    val sharedPrefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
//                    sharedPrefs.edit().putString("timetable_data", responseBody).apply()
//                    Log.d("inside line 206",responseBody)
//                    Log.d("inside line 97","hi")
//                    // Update the widget
//                    updateAppWidget(context, appWidgetManager, appWidgetId)
//                }
//            }
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//    }.start()
//}