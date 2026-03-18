import 'dart:async';

import 'package:home_widget/home_widget.dart';
import 'package:onestop_ui/index.dart';

class HomeFoodWidgetService {
  static const String _androidWidgetName = 'FoodHomeWidgetProvider';
  static const String _iosWidgetName = 'FoodWidget';

  static Timer? _debounce;

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.swciitg.onestop2');
    } catch (_) {}
  }

  /// Sync pre-fetched meal data to the home screen widget.
  static Future<void> syncMealData({
    required String mealName,
    required String endTime,
    required String items,
  }) async {
    try {
      final isDark = ThemeStore.instance.isDarkMode;

      await HomeWidget.saveWidgetData<String>('food_meal_name', mealName);
      await HomeWidget.saveWidgetData<String>('food_meal_items', items);
      await HomeWidget.saveWidgetData<String>('food_end_time', endTime);
      await HomeWidget.saveWidgetData<bool>('food_is_dark', isDark);
      await HomeWidget.saveWidgetData<String>('food_deeplink', 'onestopiitg://home2?tab=1');

      // Debounce the native widget refresh to avoid rapid-fire updates
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        HomeWidget.updateWidget(
          androidName: _androidWidgetName,
          iOSName: _iosWidgetName,
        );
      });
    } catch (_) {}
  }
}
