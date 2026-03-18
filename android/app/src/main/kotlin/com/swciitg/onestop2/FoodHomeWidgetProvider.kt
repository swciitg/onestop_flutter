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
                hideItems(views)
            } else {
                views.setViewVisibility(R.id.foodNoData, View.GONE)

                val badge = if (!endTime.isNullOrBlank()) {
                    "${mealName.uppercase()} \u2022 ENDS $endTime"
                } else {
                    mealName.uppercase()
                }
                views.setTextViewText(R.id.foodMealBadge, badge)

                val items = mealItems?.split("\n")?.filter { it.isNotBlank() } ?: emptyList()
                val itemIds = listOf(R.id.foodItem1, R.id.foodItem2, R.id.foodItem3, R.id.foodItem4)

                for (i in itemIds.indices) {
                    if (i < items.size) {
                        views.setViewVisibility(itemIds[i], View.VISIBLE)
                        views.setTextViewText(itemIds[i], items[i])
                    } else {
                        views.setViewVisibility(itemIds[i], View.GONE)
                    }
                }
            }

            setupClickIntent(context, views, deepLink, appWidgetId)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun hideItems(views: RemoteViews) {
        views.setViewVisibility(R.id.foodItem1, View.GONE)
        views.setViewVisibility(R.id.foodItem2, View.GONE)
        views.setViewVisibility(R.id.foodItem3, View.GONE)
        views.setViewVisibility(R.id.foodItem4, View.GONE)
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
        views.setTextColor(R.id.foodItem1, itemColor)
        views.setTextColor(R.id.foodItem2, itemColor)
        views.setTextColor(R.id.foodItem3, itemColor)
        views.setTextColor(R.id.foodItem4, itemColor)
        views.setTextColor(R.id.foodNoData, noDataColor)
    }

    private fun setupClickIntent(context: Context, views: RemoteViews, deepLink: String, appWidgetId: Int) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(deepLink)).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
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
