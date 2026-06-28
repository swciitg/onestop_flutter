import 'dart:async';
import 'dart:io' show Platform;

import 'package:home_widget/home_widget.dart';
import 'package:onestop_ui/index.dart';

class HomeGateLogWidgetService {
  static const String _qualifiedAndroidWidgetName = 'com.swciitg.onestop2.GateLogHomeWidgetProvider';

  static Timer? _debounce;

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.swciitg.onestop2');
    } catch (_) {}
  }

  /// Call after fetching latest gate log entry.
  /// [isCheckedOut] true means the user is currently outside campus.
  /// [destination] e.g. "City", "Khokha", etc.
  static Future<void> syncGateLogStatus({
    required bool isCheckedOut,
    String? destination,
  }) async {
    try {
      final isDark = ThemeStore.instance.isDarkMode;

      await HomeWidget.saveWidgetData<bool>('gl_is_checked_out', isCheckedOut);
      await HomeWidget.saveWidgetData<String>('gl_destination', destination ?? '');
      await HomeWidget.saveWidgetData<bool>('gl_is_dark', isDark);

      // On iOS, skip updateWidget — see HomeFoodWidgetService for details.
      if (Platform.isAndroid) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          HomeWidget.updateWidget(qualifiedAndroidName: _qualifiedAndroidWidgetName);
        });
      }
    } catch (_) {}
  }
}
