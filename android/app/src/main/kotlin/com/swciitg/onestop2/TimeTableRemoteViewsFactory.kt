package com.swciitg.onestop2


import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.google.gson.Gson
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class TimeTableRemoteViewsFactory(private val context: Context, intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    private val dataList = mutableListOf<Course>()
    val timetableData = intent.getStringExtra("timetable_data_key")
    override fun onCreate() {
        // Initialize the data
        println(timetableData)
        val gson = Gson()
        println("22")
        if(timetableData=="[]"){
            return
        }
        val response = gson.fromJson(timetableData, TimeTableResponse::class.java)
        val day = getCurrentDay()  // e.g., "Monday"
       println("24")
        val filteredCourses = filterAndSortCourses(response.courses, day)
        for(course in filteredCourses){
            println(course.timings.Friday)
            println(course.course)
            println(course.code)
        }
        dataList.addAll(filteredCourses)
        println("======================== ${dataList.size}")
    }

    override fun onDataSetChanged() {
        // Update data here if needed
        if(dataList.isNotEmpty()){
            getViewAt(0)
        }
    }

    override fun onDestroy() {
        // Clean up resources
        dataList.clear()
    }

    override fun getCount(): Int = dataList.size

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.timetable_item)
        val day = getCurrentDay()
        val timing = when (day) {
            "Monday" -> dataList[position].timings.Monday
            "Tuesday" -> dataList[position].timings.Tuesday
            "Wednesday" -> dataList[position].timings.Wednesday
            "Thursday" -> dataList[position].timings.Thursday
            "Friday" -> dataList[position].timings.Friday
            else -> dataList[position].timings.Monday
        }
        views.setTextViewText(R.id.tvTimeRange, timing)
        views.setTextViewText(R.id.tvCourseTitle, dataList[position].course)
        views.setTextViewText(R.id.tvCourseCode, dataList[position].code)
        return views
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
    private fun getCurrentDay(): String {
        val calendar = Calendar.getInstance()
        val dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK)
        return when (dayOfWeek) {
            Calendar.MONDAY -> "Monday"
            Calendar.TUESDAY -> "Tuesday"
            Calendar.WEDNESDAY -> "Wednesday"
            Calendar.THURSDAY -> "Thursday"
            Calendar.FRIDAY -> "Friday"
            Calendar.SATURDAY -> "Monday"
            Calendar.SUNDAY -> "Tuesday"
            else -> "Wednesday"
        }
    }

    private fun filterAndSortCourses(courses: List<Course>, day: String): List<Course> {
        val filteredCourses = courses.filter { course ->
            try {
                val field = course.timings::class.java.getDeclaredField(day)
                field.isAccessible = true
                val timing = field.get(course.timings) as? String
                timing != null && timing.isNotEmpty()
            } catch (e: NoSuchFieldException) {
                false
            } catch (e: IllegalAccessException) {
                false
            }
        }
        return filteredCourses
    }

}
