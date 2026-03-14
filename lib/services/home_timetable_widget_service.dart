import 'package:intl/intl.dart';
import 'package:home_widget/home_widget.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_ui/index.dart';

class HomeTimetableWidgetService {
  static const String _androidWidgetName = 'TimetableHomeWidgetProvider';
  static const String _iosWidgetName = 'TimetableWidget';

  static const String _keyTitle = 'tt_title';
  static const String _keyDate = 'tt_date';
  static const String _keyHeadlinePrefix = 'tt_headline_prefix';
  static const String _keyHeadlineValue = 'tt_headline_value';
  static const String _keyNextCourse = 'tt_next_course';
  static const String _keyNextClassStartEpoch = 'tt_next_class_start_epoch';
  static const String _keyOtherTime = 'tt_other_time';
  static const String _keyOtherCourse = 'tt_other_course';
  static const String _keyUpdatedAt = 'tt_updated_at';
  static const String _keyDeepLink = 'tt_deeplink';
  static const String _keyIsDark = 'tt_is_dark';

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.swciitg.onestop2');
    } catch (_) {
      // App group is only required when iOS widget extension is configured.
    }
  }

  static Future<void> sync(List<CourseModel> classes) async {
    final now = DateTime.now();
    final nextClass = classes.isNotEmpty ? classes.first : null;
    final otherClass = classes.length > 1 ? classes[1] : null;

    String headlinePrefix = 'No upcoming classes';
    String headlineValue = '';
    String nextCourse = '';
    String nextClassStartEpoch = '';
    String otherTime = '';
    String otherCourse = '';
    final isDark = ThemeStore.instance.isDarkMode;

    if (nextClass != null) {
      final courseName = nextClass.course ?? '';
      if (courseName == 'Happy Weekend !' || courseName == 'No upcoming classes') {
        headlinePrefix = courseName;
      } else {
        headlinePrefix = 'Class in';
        headlineValue = _timeValueLabel(nextClass, now);
        nextCourse = _courseLabel(nextClass);
        nextClassStartEpoch = _nextClassStartEpoch(nextClass, now) ?? '';
      }
    }

    if (otherClass != null) {
      final courseName = otherClass.course ?? '';
      if (courseName != 'Happy Weekend !' && courseName != 'No upcoming classes') {
        otherCourse = _courseLabel(otherClass);
        otherTime = _displayStartTime(otherClass, now);
      }
    }

    await HomeWidget.saveWidgetData<String>(_keyTitle, 'Time Table');
    await HomeWidget.saveWidgetData<String>(_keyDate, _formattedDate(now));
    await HomeWidget.saveWidgetData<String>(_keyHeadlinePrefix, headlinePrefix);
    await HomeWidget.saveWidgetData<String>(_keyHeadlineValue, headlineValue);
    await HomeWidget.saveWidgetData<String>(_keyNextCourse, nextCourse);
    await HomeWidget.saveWidgetData<String>(_keyNextClassStartEpoch, nextClassStartEpoch);
    await HomeWidget.saveWidgetData<String>(_keyOtherTime, otherTime);
    await HomeWidget.saveWidgetData<String>(_keyOtherCourse, otherCourse);
    await HomeWidget.saveWidgetData<String>(_keyUpdatedAt, DateFormat('hh:mm a').format(now));
    await HomeWidget.saveWidgetData<String>(_keyDeepLink, 'onestopiitg://home2');
    await HomeWidget.saveWidgetData<bool>(_keyIsDark, isDark);

    await HomeWidget.updateWidget(androidName: _androidWidgetName, iOSName: _iosWidgetName);
  }

  static String _formattedDate(DateTime date) {
    final day = date.day;
    var suffix = 'TH';
    if (day % 10 == 1 && day != 11) {
      suffix = 'ST';
    } else if (day % 10 == 2 && day != 12) {
      suffix = 'ND';
    } else if (day % 10 == 3 && day != 13) {
      suffix = 'RD';
    }
    return '$day$suffix ${DateFormat('MMMM').format(date).toUpperCase()}';
  }

  static String _courseLabel(CourseModel course) {
    final code = (course.code ?? '').trim();
    final name = (course.course ?? '').trim();
    if (code.isNotEmpty && name.isNotEmpty) {
      return '$code - $name';
    }
    return code.isNotEmpty ? code : name;
  }

  static String _timeValueLabel(CourseModel course, DateTime now) {
    final start = _classStartDateTime(course, now);
    if (start == null) {
      return '';
    }

    final diff = start.difference(now);

    if (diff.isNegative) {
      return 'Started';
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) {
      final h = hours == 1 ? 'hr' : 'hrs';
      if (minutes > 0) {
        final m = minutes == 1 ? 'min' : 'mins';
        return '$hours $h $minutes $m';
      }
      return '$hours $h';
    }

    if (minutes > 0) {
      final m = minutes == 1 ? 'min' : 'mins';
      return '$minutes $m';
    }

    return 'Running now';
  }

  static String? _nextClassStartEpoch(CourseModel course, DateTime now) {
    final start = _classStartDateTime(course, now);
    return start?.millisecondsSinceEpoch.toString();
  }

  static String _displayStartTime(CourseModel course, DateTime now) {
    final start = _classStartDateTime(course, now);
    if (start == null) {
      return '';
    }
    return DateFormat('hh:mm a').format(start);
  }

  static DateTime? _classStartDateTime(CourseModel course, DateTime now) {
    final timings = course.timings;
    if (timings == null || timings.isEmpty) {
      return null;
    }

    final day = DateFormat.EEEE().format(now);
    final slot = timings[day];
    if (slot == null || slot.isEmpty) {
      return null;
    }

    try {
      final parsed = DateFormat('hh:00 - hh:55 a').parse(slot);
      return DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
    } catch (_) {
      return null;
    }
  }
}
