import 'dart:async';
import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:onestop_dev/models/timetable/timetable_day.dart';
import 'package:onestop_ui/index.dart';

class HomeTimetableWidgetService {
  static const String _androidWidgetName = 'TimetableHomeWidgetProvider';
  static const String _iosWidgetName = 'TimetableWidget';

  static Timer? _debounce;
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.swciitg.onestop2');
    } catch (_) {}
  }

  /// Push the full week's timetable as JSON so the widget can compute
  /// current/upcoming classes on its own every update cycle.
  static Future<void> syncFullTimetable(List<TimetableDay> allDays) async {
    // Build a map: { "Monday": [ {code, course, startEpochTemplate}, ... ], ... }
    // We store the raw timing string per day so Kotlin can parse & compare at widget-update time.
    final Map<String, dynamic> weekData = {};

    for (int i = 0; i < 5 && i < allDays.length; i++) {
      final day = _days[i];
      final courses = [...allDays[i].morning, ...allDays[i].afternoon];
      weekData[day] = courses.map((c) {
        return <String, String>{
          'code': (c.code ?? '').trim(),
          'course': (c.course ?? '').trim(),
          'timing': (c.timings?[day] ?? '').trim(), // e.g. "09:00 - 09:55 AM"
        };
      }).toList();
    }

    final isDark = ThemeStore.instance.isDarkMode;

    await HomeWidget.saveWidgetData<String>('tt_week_data', jsonEncode(weekData));
    await HomeWidget.saveWidgetData<bool>('tt_is_dark', isDark);
    await HomeWidget.saveWidgetData<String>('tt_deeplink', 'onestopiitg://home2');

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      HomeWidget.updateWidget(androidName: _androidWidgetName, iOSName: _iosWidgetName);
    });
  }
}
