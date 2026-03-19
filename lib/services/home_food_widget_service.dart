import 'dart:async';
import 'dart:io' show Platform;

import 'package:home_widget/home_widget.dart';
import 'package:onestop_ui/index.dart';

class HomeFoodWidgetService {
  static const String _qualifiedAndroidWidgetName = 'com.swciitg.onestop2.FoodHomeWidgetProvider';

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

      // On iOS, skip updateWidget — WidgetKit's reloadTimelines triggers a
      // scene-snapshot that recursively traverses Flutter's deep UIView tree
      // (24 000+ levels), causing a stack overflow. iOS widgets use timeline
      // refresh to pick up new UserDefaults data instead.
      if (Platform.isAndroid) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          HomeWidget.updateWidget(qualifiedAndroidName: _qualifiedAndroidWidgetName);
        });
      }
    } catch (_) {}
  }
}
