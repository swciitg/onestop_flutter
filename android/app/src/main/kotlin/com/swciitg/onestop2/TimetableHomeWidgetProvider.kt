package com.swciitg.onestop2

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.concurrent.TimeUnit

class TimetableHomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val views = RemoteViews(context.packageName, R.layout.timetable_home_widget)

            val title = widgetData.getString("tt_title", "Time Table") ?: "Time Table"
            val date = widgetData.getString("tt_date", "") ?: ""
            val headlinePrefix = widgetData.getString("tt_headline_prefix", "No upcoming classes") ?: "No upcoming classes"
            val headlineValueStored = widgetData.getString("tt_headline_value", "") ?: ""
            val nextCourse = widgetData.getString("tt_next_course", "") ?: ""
            val nextClassStartEpoch = widgetData.getString("tt_next_class_start_epoch", "") ?: ""
            val otherTime = widgetData.getString("tt_other_time", "") ?: ""
            val otherCourse = widgetData.getString("tt_other_course", "") ?: ""
            val updatedAt = widgetData.getString("tt_updated_at", "") ?: ""
            val deepLink = widgetData.getString("tt_deeplink", "onestopiitg://home2") ?: "onestopiitg://home2"
            val isDark = widgetData.getBoolean("tt_is_dark", false)

            val headlineValue = if (headlinePrefix == "Class in") {
                calculateRelativeTime(nextClassStartEpoch)
            } else {
                headlineValueStored
            }

            views.setTextViewText(R.id.ttTitle, title)
            views.setTextViewText(R.id.ttDate, date)
            views.setTextViewText(R.id.ttHeadlinePrefix, headlinePrefix)
            views.setTextViewText(R.id.ttHeadlineValue, headlineValue)
            views.setTextViewText(R.id.ttNextCourse, nextCourse)
            views.setTextViewText(R.id.ttOtherTime, otherTime)
            views.setTextViewText(R.id.ttOtherCourse, otherCourse)
            views.setTextViewText(R.id.ttUpdatedAt, if (updatedAt.isBlank()) "" else "Updated $updatedAt")

            val hasHeadlineValue = headlineValue.isNotBlank()
            views.setViewVisibility(R.id.ttHeadlineValue, if (hasHeadlineValue) View.VISIBLE else View.GONE)

            val hasOtherClass = otherTime.isNotBlank() || otherCourse.isNotBlank()
            views.setViewVisibility(R.id.ttOtherCard, if (hasOtherClass) View.VISIBLE else View.GONE)

            applyTheme(views, isDark)

            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(deepLink)).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }

            val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }

            val pendingIntent = PendingIntent.getActivity(
                context,
                appWidgetId,
                intent,
                pendingIntentFlags,
            )

            views.setOnClickPendingIntent(R.id.ttWidgetRoot, pendingIntent)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun calculateRelativeTime(startEpochString: String): String {
        val startEpoch = startEpochString.toLongOrNull() ?: return ""
        val now = System.currentTimeMillis()
        val diffMillis = startEpoch - now

        if (diffMillis <= 0) {
            return "Started"
        }

        val totalMinutes = TimeUnit.MILLISECONDS.toMinutes(diffMillis)
        val hours = totalMinutes / 60
        val minutes = totalMinutes % 60

        if (hours > 0) {
            val hourText = if (hours == 1L) "hr" else "hrs"
            if (minutes > 0) {
                val minuteText = if (minutes == 1L) "min" else "mins"
                return "$hours $hourText $minutes $minuteText"
            }
            return "$hours $hourText"
        }

        val minuteText = if (minutes == 1L) "min" else "mins"
        return "$minutes $minuteText"
    }

    private fun applyTheme(views: RemoteViews, isDark: Boolean) {
        val cardBackground = if (isDark) {
            R.drawable.timetable_widget_background_dark
        } else {
            R.drawable.timetable_widget_background_light
        }
        val innerBackground = if (isDark) {
            R.drawable.timetable_widget_inner_card_dark
        } else {
            R.drawable.timetable_widget_inner_card_light
        }

        views.setInt(R.id.ttWidgetRoot, "setBackgroundResource", cardBackground)
        views.setInt(R.id.ttOtherCard, "setBackgroundResource", innerBackground)

        val titleColor = if (isDark) 0xFFFDFDFCL.toInt() else 0xFF000000.toInt()
        val dateColor = if (isDark) 0xFF696A74.toInt() else 0xFF98999F.toInt()
        val headlineColor = titleColor
        val headlineValueColor = if (isDark) 0xFF1AB056.toInt() else 0xFF148440.toInt()
        val courseColor = if (isDark) 0xFF98999F.toInt() else 0xFF6E6F77.toInt()
        val otherCourseColor = titleColor

        views.setTextColor(R.id.ttTitle, titleColor)
        views.setTextColor(R.id.ttDot, dateColor)
        views.setTextColor(R.id.ttDate, dateColor)
        views.setTextColor(R.id.ttHeadlinePrefix, headlineColor)
        views.setTextColor(R.id.ttHeadlineValue, headlineValueColor)
        views.setTextColor(R.id.ttNextCourse, courseColor)
        views.setTextColor(R.id.ttOtherTime, courseColor)
        views.setTextColor(R.id.ttOtherCourse, otherCourseColor)
        views.setTextColor(R.id.ttUpdatedAt, dateColor)
    }
}
