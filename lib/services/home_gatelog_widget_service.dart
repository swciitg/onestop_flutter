import 'dart:async';

import 'package:home_widget/home_widget.dart';
import 'package:onestop_ui/index.dart';

class HomeGateLogWidgetService {
  static const String _androidWidgetName = 'GateLogHomeWidgetProvider';
  static const String _iosWidgetName = 'GateLogWidget';

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
