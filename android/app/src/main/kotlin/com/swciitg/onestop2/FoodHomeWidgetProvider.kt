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

class FoodHomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val views = RemoteViews(context.packageName, R.layout.food_home_widget)

            val mealName = widgetData.getString("food_meal_name", null)
            val mealItems = widgetData.getString("food_meal_items", null)
            val endTime = widgetData.getString("food_end_time", null)
            val isDark = widgetData.getBoolean("food_is_dark", false)
            val deepLink = widgetData.getString("food_deeplink", "onestopiitg://home2?tab=1")
                ?: "onestopiitg://home2?tab=1"

            applyTheme(views, isDark)

            if (mealName.isNullOrBlank()) {
                // No data
                views.setTextViewText(R.id.foodMealBadge, "")
                views.setViewVisibility(R.id.foodNoData, View.VISIBLE)
                views.setViewVisibility(R.id.foodItems, View.GONE)
            } else {
                views.setViewVisibility(R.id.foodNoData, View.GONE)

                val badge = if (!endTime.isNullOrBlank()) {
                    "${mealName.uppercase()} \u2022 ENDS $endTime"
                } else {
                    mealName.uppercase()
                }
                views.setTextViewText(R.id.foodMealBadge, badge)

                val items = mealItems?.split("\n")?.filter { it.isNotBlank() } ?: emptyList()
                if (items.isNotEmpty()) {
                    views.setTextViewText(R.id.foodItems, items.joinToString(", "))
                    views.setViewVisibility(R.id.foodItems, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.foodItems, View.GONE)
                }
            }

            setupClickIntent(context, views, deepLink, appWidgetId)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun applyTheme(views: RemoteViews, isDark: Boolean) {
        val bg = if (isDark) R.drawable.food_widget_background_dark
            else R.drawable.food_widget_background_light
        views.setInt(R.id.foodWidgetRoot, "setBackgroundResource", bg)

        val titleColor = if (isDark) 0xFFFDFDFC.toInt() else 0xFF000000.toInt()
        val badgeColor = if (isDark) 0xFF6F6F6F.toInt() else 0xFF98999F.toInt()
        val itemColor = if (isDark) 0xFFFDFDFC.toInt() else 0xFF000000.toInt()
        val noDataColor = if (isDark) 0xFF6F6F6F.toInt() else 0xFF98999F.toInt()

        views.setTextColor(R.id.foodTitle, titleColor)
        views.setTextColor(R.id.foodMealBadge, badgeColor)
        views.setTextColor(R.id.foodItems, itemColor)
        views.setTextColor(R.id.foodNoData, noDataColor)
    }

    private fun setupClickIntent(context: Context, views: RemoteViews, deepLink: String, appWidgetId: Int) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(deepLink)).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingIntent = PendingIntent.getActivity(context, appWidgetId, intent, flags)
        views.setOnClickPendingIntent(R.id.foodWidgetRoot, pendingIntent)
    }
}
