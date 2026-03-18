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
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class TimetableHomeWidgetProvider : HomeWidgetProvider() {

    data class WidgetCourse(
        val code: String,
        val course: String,
        val startEpoch: Long,  // millis since epoch for today's class start
    )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val views = RemoteViews(context.packageName, R.layout.timetable_home_widget)

            val weekJson = widgetData.getString("tt_week_data", null)
            val deepLink = widgetData.getString("tt_deeplink", "onestopiitg://timetable") ?: "onestopiitg://timetable"
            val isDark = widgetData.getBoolean("tt_is_dark", false)

            val now = System.currentTimeMillis()
            val cal = Calendar.getInstance()
            val dayOfWeek = cal.get(Calendar.DAY_OF_WEEK) // 1=Sun, 7=Sat

            // Header
            views.setTextViewText(R.id.ttTitle, "Time Table")
            views.setTextViewText(R.id.ttDate, formatDate(cal))

            val isWeekend = dayOfWeek == Calendar.SATURDAY || dayOfWeek == Calendar.SUNDAY

            if (isWeekend) {
                showNoClassState(views, "Happy Weekend !")
                views.setTextViewText(R.id.ttUpdatedAt, "Updated ${formatTime(now)}")
                applyTheme(views, isDark, isOngoing = false, hasClasses = false)
                setupClickIntent(context, views, deepLink, appWidgetId)
                appWidgetManager.updateAppWidget(appWidgetId, views)
                return@forEach
            }

            if (weekJson.isNullOrBlank()) {
                showNoClassState(views, "No upcoming classes")
                views.setTextViewText(R.id.ttUpdatedAt, "Updated ${formatTime(now)}")
                applyTheme(views, isDark, isOngoing = false, hasClasses = false)
                setupClickIntent(context, views, deepLink, appWidgetId)
                appWidgetManager.updateAppWidget(appWidgetId, views)
                return@forEach
            }

            // Parse courses for today
            val todayCourses = parseTodayCourses(weekJson, dayOfWeek, cal)

            // Find upcoming & ongoing classes:
            // A class is "ongoing" if startEpoch <= now AND now < startEpoch + 55min
            // A class is "upcoming" if startEpoch > now
            val classEndOffsetMs = 55 * 60 * 1000L

            val ongoingOrUpcoming = todayCourses.filter { c ->
                c.startEpoch + classEndOffsetMs > now
            }

            if (ongoingOrUpcoming.isEmpty()) {
                showNoClassState(views, "No upcoming classes")
                views.setTextViewText(R.id.ttUpdatedAt, "Updated ${formatTime(now)}")
                applyTheme(views, isDark, isOngoing = false, hasClasses = false)
                setupClickIntent(context, views, deepLink, appWidgetId)
                appWidgetManager.updateAppWidget(appWidgetId, views)
                return@forEach
            }

            val currentClass = ongoingOrUpcoming.first()
            val isOngoing = currentClass.startEpoch <= now
            val upcomingClasses = if (isOngoing) ongoingOrUpcoming.drop(1) else ongoingOrUpcoming.drop(1)

            // Show classes section
            views.setViewVisibility(R.id.ttClassesSection, View.VISIBLE)
            views.setViewVisibility(R.id.ttNoClassMessage, View.GONE)

            // Left card: current/next class
            views.setTextViewText(R.id.ttStatusBadge, if (isOngoing) "ONGOING" else "UP NEXT")

            if (isOngoing) {
                views.setViewVisibility(R.id.ttTimeInfo, View.GONE)
            } else {
                val remaining = formatTimeRemaining(currentClass.startEpoch - now)
                if (remaining.isNotBlank()) {
                    views.setTextViewText(R.id.ttTimeInfo, "In $remaining")
                    views.setViewVisibility(R.id.ttTimeInfo, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.ttTimeInfo, View.GONE)
                }
            }

            views.setTextViewText(R.id.ttCourseCode, currentClass.code)
            views.setTextViewText(R.id.ttCourseName, currentClass.course)

            val classTimeStr = formatTime(currentClass.startEpoch)
            if (classTimeStr.isNotBlank()) {
                views.setTextViewText(R.id.ttClassTime, classTimeStr)
                views.setViewVisibility(R.id.ttClassTime, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.ttClassTime, View.GONE)
            }

            // Right section: upcoming classes (up to 3)
            val hasUpcoming = upcomingClasses.isNotEmpty()
            views.setViewVisibility(R.id.ttRightSection, if (hasUpcoming) View.VISIBLE else View.GONE)

            val upcomingIds = listOf(
                Triple(R.id.ttUpcoming1, R.id.ttUpcoming1Time, R.id.ttUpcoming1Course),
                Triple(R.id.ttUpcoming2, R.id.ttUpcoming2Time, R.id.ttUpcoming2Course),
                Triple(R.id.ttUpcoming3, R.id.ttUpcoming3Time, R.id.ttUpcoming3Course),
            )

            for (i in 0 until 2) {
                val (cardId, timeId, courseId) = upcomingIds[i]
                if (i < upcomingClasses.size) {
                    val c = upcomingClasses[i]
                    views.setViewVisibility(cardId, View.VISIBLE)
                    views.setTextViewText(timeId, formatTime(c.startEpoch))
                    val label = if (c.code.isNotBlank() && c.course.isNotBlank()) {
                        "${c.code} - ${c.course}"
                    } else c.code.ifBlank { c.course }
                    views.setTextViewText(courseId, label)
                } else {
                    views.setViewVisibility(cardId, View.GONE)
                }
            }
            // Always hide 3rd card in compact mode
            views.setViewVisibility(R.id.ttUpcoming3, View.GONE)

            applyTheme(views, isDark, isOngoing, hasClasses = true)
            setupClickIntent(context, views, deepLink, appWidgetId)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun parseTodayCourses(weekJson: String, dayOfWeek: Int, cal: Calendar): List<WidgetCourse> {
        val dayName = when (dayOfWeek) {
            Calendar.MONDAY -> "Monday"
            Calendar.TUESDAY -> "Tuesday"
            Calendar.WEDNESDAY -> "Wednesday"
            Calendar.THURSDAY -> "Thursday"
            Calendar.FRIDAY -> "Friday"
            else -> return emptyList()
        }

        return try {
            val root = JSONObject(weekJson)
            val dayArray = root.optJSONArray(dayName) ?: return emptyList()
            val courses = mutableListOf<WidgetCourse>()
            val timeFormat = SimpleDateFormat("hh:mm - hh:mm a", Locale.US)

            for (i in 0 until dayArray.length()) {
                val obj = dayArray.getJSONObject(i)
                val code = obj.optString("code", "")
                val course = obj.optString("course", "")
                val timing = obj.optString("timing", "")

                if (timing.isBlank()) continue

                val startEpoch = parseTimingToEpoch(timing, cal, timeFormat)
                if (startEpoch > 0) {
                    courses.add(WidgetCourse(code, course, startEpoch))
                }
            }

            courses.sortBy { it.startEpoch }
            courses
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun parseTimingToEpoch(timing: String, cal: Calendar, timeFormat: SimpleDateFormat): Long {
        // Timing format: "09:00 - 09:55 AM" or "02:00 - 02:55 PM"
        return try {
            val parsed = timeFormat.parse(timing) ?: return 0L
            val parsedCal = Calendar.getInstance().apply { time = parsed }

            // Build today's date + parsed time
            val todayCal = Calendar.getInstance().apply {
                set(Calendar.YEAR, cal.get(Calendar.YEAR))
                set(Calendar.MONTH, cal.get(Calendar.MONTH))
                set(Calendar.DAY_OF_MONTH, cal.get(Calendar.DAY_OF_MONTH))
                set(Calendar.HOUR_OF_DAY, parsedCal.get(Calendar.HOUR_OF_DAY))
                set(Calendar.MINUTE, parsedCal.get(Calendar.MINUTE))
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }

            todayCal.timeInMillis
        } catch (e: Exception) {
            0L
        }
    }

    private fun showNoClassState(views: RemoteViews, message: String) {
        views.setViewVisibility(R.id.ttClassesSection, View.GONE)
        views.setViewVisibility(R.id.ttNoClassMessage, View.VISIBLE)
        views.setTextViewText(R.id.ttNoClassMessage, message)
    }

    private fun formatDate(cal: Calendar): String {
        val day = cal.get(Calendar.DAY_OF_MONTH)
        val suffix = when {
            day % 10 == 1 && day != 11 -> "ST"
            day % 10 == 2 && day != 12 -> "ND"
            day % 10 == 3 && day != 13 -> "RD"
            else -> "TH"
        }
        val month = SimpleDateFormat("MMMM", Locale.getDefault()).format(cal.time).uppercase()
        return "$day$suffix $month"
    }

    private fun formatTime(epochMs: Long): String {
        return SimpleDateFormat("hh:mm a", Locale.getDefault()).format(Date(epochMs))
    }

    private fun formatTimeRemaining(diffMs: Long): String {
        if (diffMs <= 0) return ""
        val totalMinutes = (diffMs / 60000).toInt()
        val hours = totalMinutes / 60
        val mins = totalMinutes % 60

        return when {
            hours > 0 && mins > 0 -> "$hours ${if (hours == 1) "hr" else "hrs"} $mins ${if (mins == 1) "min" else "mins"}"
            hours > 0 -> "$hours ${if (hours == 1) "hr" else "hrs"}"
            mins > 0 -> "$mins ${if (mins == 1) "min" else "mins"}"
            else -> ""
        }
    }

    private fun setupClickIntent(context: Context, views: RemoteViews, deepLink: String, appWidgetId: Int) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(deepLink)).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingIntent = PendingIntent.getActivity(context, appWidgetId, intent, pendingIntentFlags)
        views.setOnClickPendingIntent(R.id.ttWidgetRoot, pendingIntent)
    }

    private fun applyTheme(views: RemoteViews, isDark: Boolean, isOngoing: Boolean, hasClasses: Boolean) {
        // Card background
        val cardBackground = if (isDark) R.drawable.timetable_widget_background_dark
            else R.drawable.timetable_widget_background_light
        views.setInt(R.id.ttWidgetRoot, "setBackgroundResource", cardBackground)

        // Inner card backgrounds for upcoming classes
        val innerBackground = if (isDark) R.drawable.timetable_widget_inner_card_dark
            else R.drawable.timetable_widget_inner_card_light
        views.setInt(R.id.ttUpcoming1, "setBackgroundResource", innerBackground)
        views.setInt(R.id.ttUpcoming2, "setBackgroundResource", innerBackground)
        views.setInt(R.id.ttUpcoming3, "setBackgroundResource", innerBackground)

        // Left card: green for ongoing, blue for upcoming
        if (hasClasses) {
            val leftCardBg = if (isOngoing) {
                if (isDark) R.drawable.timetable_widget_left_card_green_dark
                else R.drawable.timetable_widget_left_card_green_light
            } else {
                if (isDark) R.drawable.timetable_widget_left_card_blue_dark
                else R.drawable.timetable_widget_left_card_blue_light
            }
            views.setInt(R.id.ttLeftCard, "setBackgroundResource", leftCardBg)
        }

        // OColor-based colors
        val titleColor = if (isDark) 0xFFFDFDFC.toInt() else 0xFF000000.toInt()       // black
        val dateColor = if (isDark) 0xFF6F6F6F.toInt() else 0xFF98999F.toInt()         // gray500
        val courseNameColor = if (isDark) 0xFF9B9B9B.toInt() else 0xFF6E6F77.toInt()    // gray600
        val classTimeColor = if (isDark) 0xFF6F6F6F.toInt() else 0xFF98999F.toInt()     // gray500
        val upcomingTimeColor = dateColor
        val upcomingCourseColor = titleColor

        val badgeColor = if (isOngoing) {
            if (isDark) 0xFF14BD56.toInt() else 0xFF1AB056.toInt()  // green500
        } else {
            if (isDark) 0xFF3887FF.toInt() else 0xFF005FF0.toInt()  // blue500
        }
        val timeInfoColor = if (isOngoing) {
            if (isDark) 0xFF085E2A.toInt() else 0xFF085E2A.toInt()  // green700
        } else {
            if (isDark) 0xFF1A75FF.toInt() else 0xFF004BBD.toInt()  // blue600
        }
        val noClassColor = if (isDark) 0xFF14BD56.toInt() else 0xFF1AB056.toInt()  // green500

        // Header
        views.setTextColor(R.id.ttTitle, titleColor)
        views.setTextColor(R.id.ttDot, dateColor)
        views.setTextColor(R.id.ttDate, dateColor)
        views.setTextColor(R.id.ttUpdatedAt, dateColor)
        views.setTextColor(R.id.ttNoClassMessage, noClassColor)

        // Left card
        views.setTextColor(R.id.ttStatusBadge, 0xFFFFFFFF.toInt())
        views.setInt(R.id.ttStatusBadge, "setBackgroundColor", badgeColor)
        views.setTextColor(R.id.ttTimeInfo, timeInfoColor)
        views.setTextColor(R.id.ttCourseCode, titleColor)
        views.setTextColor(R.id.ttCourseName, courseNameColor)
        views.setTextColor(R.id.ttClassTime, classTimeColor)

        // Upcoming cards
        views.setTextColor(R.id.ttUpcoming1Time, upcomingTimeColor)
        views.setTextColor(R.id.ttUpcoming1Course, upcomingCourseColor)
        views.setTextColor(R.id.ttUpcoming2Time, upcomingTimeColor)
        views.setTextColor(R.id.ttUpcoming2Course, upcomingCourseColor)
        views.setTextColor(R.id.ttUpcoming3Time, upcomingTimeColor)
        views.setTextColor(R.id.ttUpcoming3Course, upcomingCourseColor)
    }
}
