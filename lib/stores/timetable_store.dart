// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/class_timings.dart';
import 'package:onestop_dev/globals/working_days.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/models/timetable/timetable_day.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/services/home_timetable_widget_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/timetable/timetable_tile.dart';
import 'package:onestop_dev/widgets/ui/text_divider.dart';
import 'package:onestop_ui/index.dart';

part 'timetable_store.g.dart';

enum ExamMode { none, upcoming, during }

class TimetableStore = _TimetableStore with _$TimetableStore;

abstract class _TimetableStore with Store {
  //List of time table of each day of the week
  List<TimetableDay> allTimetableCourses = List.generate(5, (index) => TimetableDay());

  @observable
  bool isProcessed = false;

  @observable
  RegisteredCourses? courses;

  Future<RegisteredCourses> getCourses() async {
    courses ??= await DataService.getTimeTable(roll: LoginStore.userData['rollNo']);
    return courses!;
  }

  Future<String> initialiseTT() async {
    if (!isProcessed) {
      initialiseDates();
      await processTimetable();
      isProcessed = true;
    }
    await _syncTimetableHomeWidget();
    return "Success";
  }

  Future<void> _syncTimetableHomeWidget() async {
    try {
      await HomeTimetableWidgetService.syncFullTimetable(allTimetableCourses);
    } catch (_) {
      // Widget sync is best effort and should never block timetable rendering.
    }
  }

  //List of dates to show in the date slider
  List<DateTime> dates = List.filled(5, DateTime.now());

  //Initialising the dates
  void initialiseDates() {
    dates = List.filled(5, DateTime.now());
    if (dates[0].weekday == 6 || dates[0].weekday == 7) {
      while (dates[0].weekday != 1) {
        dates[0] = dates[0].add(const Duration(days: 1));
      }
    }
    for (int i = 1; i < 5; i++) {
      dates[i] = dates[i - 1].add(const Duration(days: 1));
      if (dates[i].weekday == 6) {
        dates[i] = dates[i].add(const Duration(days: 2));
      }
    }
  }

  //index of date slider item
  @observable
  int selectedDate = 0;

  @action
  void setDate(int i) {
    selectedDate = i;
  }

  //index of selected day
  @observable
  int selectedDay =
      (DateTime.now().weekday == 6 || DateTime.now().weekday == 7) ? 0 : DateTime.now().weekday - 1;

  @action
  void setDay(int i) {
    selectedDay = i;
  }

  //Dropdown state of tt on home
  @observable
  bool showDropDown = false;

  @action
  void toggleDropDown() {
    showDropDown = !showDropDown;
  }

  @action
  void setDropDown(bool b) {
    showDropDown = b;
  }

  @observable
  bool isTimetable = true;

  @action
  void setTT() {
    isTimetable = !isTimetable;
  }

  // 0: none, 1: upcoming (1 week before), 2: during exams
  @observable
  ExamMode examMode = ExamMode.none;

  /// Whether to show cab sharing suggestion (during and up to 1 month after endsem exams)
  @observable
  bool showCabSuggestion = false;

  @action
  void setExamMode(ExamMode mode) {
    examMode = mode;
  }

  /// Calculates examMode based on dates and returns the upcoming exams.
  @action
  void calculateExamMode() {
    if (courses == null || courses!.courses == null || courses!.courses!.isEmpty) {
      examMode = ExamMode.none;
      showCabSuggestion = false;
      return;
    }

    DateTime now = DateTime.now();
    bool isMidsemDone = true;
    bool isEndsemDone = true;

    List<CourseModel> validMidsems = List.from(courses!.courses!);
    validMidsems.removeWhere((e) => e.midsem == null || e.midsem == '');
    if (validMidsems.isNotEmpty) {
      validMidsems.sort((a, b) => DateTime.parse(a.midsem!).compareTo(DateTime.parse(b.midsem!)));
      isMidsemDone = DateTime.parse(validMidsems.last.midsem!).isBefore(now);
    }

    List<CourseModel> validEndsems = List.from(courses!.courses!);
    validEndsems.removeWhere((e) => e.endsem == null || e.endsem == '');
    if (validEndsems.isNotEmpty) {
      validEndsems.sort((a, b) => DateTime.parse(a.endsem!).compareTo(DateTime.parse(b.endsem!)));
      isEndsemDone = DateTime.parse(validEndsems.last.endsem!).isBefore(now);
    }

    // Show cab suggestion during endsems and up to 1 month after last endsem
    if (validEndsems.isNotEmpty) {
      DateTime firstEnd = DateTime.parse(validEndsems.first.endsem!);
      DateTime lastEnd = DateTime.parse(validEndsems.last.endsem!);
      showCabSuggestion = now.isAfter(firstEnd) &&
          now.isBefore(lastEnd.add(const Duration(days: 30)));
    } else {
      showCabSuggestion = false;
    }

    if (!isMidsemDone && validMidsems.isNotEmpty) {
      DateTime firstMid = DateTime.parse(validMidsems.first.midsem!);
      DateTime lastMid = DateTime.parse(validMidsems.last.midsem!);
      if (now.isAfter(firstMid) && now.isBefore(lastMid.add(Duration(days: 1)))) {
        examMode = ExamMode.during; // During exams
      } else if (now.isBefore(firstMid) && firstMid.difference(now).inDays <= 7) {
        examMode = ExamMode.upcoming; // Upcoming exams in 1 week
      } else {
        examMode = ExamMode.none;
      }
    } else if (!isEndsemDone && validEndsems.isNotEmpty) {
      DateTime firstEnd = DateTime.parse(validEndsems.first.endsem!);
      DateTime lastEnd = DateTime.parse(validEndsems.last.endsem!);
      if (now.isAfter(firstEnd) && now.isBefore(lastEnd.add(Duration(days: 1)))) {
        examMode = ExamMode.during; // During exams
      } else if (now.isBefore(firstEnd) && firstEnd.difference(now).inDays <= 7) {
        examMode = ExamMode.upcoming; // Upcoming exams in 1 week
      } else {
        examMode = ExamMode.none;
      }
    } else {
      examMode = ExamMode.none;
    }
  }

  String get upcomingExamType {
    if (courses == null || courses!.courses == null) return 'Exams';
    DateTime now = DateTime.now();
    bool isMidsemDone = true;
    List<CourseModel> validMidsems = List.from(courses!.courses!);
    validMidsems.removeWhere((e) => e.midsem == null || e.midsem == '');
    if (validMidsems.isNotEmpty) {
      validMidsems.sort((a, b) => DateTime.parse(a.midsem!).compareTo(DateTime.parse(b.midsem!)));
      if (DateTime.parse(validMidsems.last.midsem!).isAfter(now)) {
        isMidsemDone = false;
      }
    }
    return !isMidsemDone ? 'Midsem Exams' : 'Endsem Exams';
  }

  List<CourseModel> get homeUpcomingExams {
    // If not calculated yet or user overridden via hardcoded var, we still return the list based on state
    if (courses == null || courses!.courses == null) return [];

    DateTime now = DateTime.now();
    bool isMidsemDone = true;

    List<CourseModel> validMidsems = List.from(courses!.courses!);
    validMidsems.removeWhere((e) => e.midsem == null || e.midsem == '');
    if (validMidsems.isNotEmpty) {
      validMidsems.sort((a, b) => DateTime.parse(a.midsem!).compareTo(DateTime.parse(b.midsem!)));
      if (DateTime.parse(validMidsems.last.midsem!).isAfter(now)) {
        isMidsemDone = false;
      }
    }

    List<CourseModel> validEndsems = List.from(courses!.courses!);
    validEndsems.removeWhere((e) => e.endsem == null || e.endsem == '');
    if (validEndsems.isNotEmpty) {
      validEndsems.sort((a, b) => DateTime.parse(a.endsem!).compareTo(DateTime.parse(b.endsem!)));
    }

    List<CourseModel> activeExams = !isMidsemDone ? validMidsems : validEndsems;

    // Only show exams that are upcoming or today
    activeExams.removeWhere((e) {
      String dateStr = !isMidsemDone ? e.midsem! : e.endsem!;
      DateTime d = DateTime.parse(dateStr);
      // Remove if it's already past (before today 00:00)
      return d.isBefore(DateTime(now.year, now.month, now.day));
    });

    return activeExams;
  }

  List<CourseModel> get homeTimeTable {
    DateTime current = DateTime.now();
    String day = DateFormat.EEEE().format(DateTime.now());
    if (current.weekday == 6 || current.weekday == 7) {
      CourseModel noClass = CourseModel();
      noClass.instructor = '';
      noClass.course = 'Happy Weekend !';
      noClass.timings = {day: ""};
      return [noClass];
    }
    current = dates[0];
    DateFormat dateFormat = DateFormat("hh:00 - hh:55 a");
    List<CourseModel> upcomingClasses = [
      ...allTimetableCourses[current.weekday - 1].morning
          .where((e) => dateFormat.parse(e.timings![day]).hour >= DateTime.now().hour)
          .toList()
          .map((e) => e),
      ...allTimetableCourses[current.weekday - 1].afternoon
          .where((e) => dateFormat.parse(e.timings![day]).hour >= DateTime.now().hour)
          .toList()
          .map((e) => e),
    ];
    if (upcomingClasses.isEmpty) {
      CourseModel noClass = CourseModel();
      noClass.instructor = '';
      noClass.course = 'No upcoming classes';
      noClass.timings = {day: ""};
      upcomingClasses.add(noClass);
    }
    return upcomingClasses;
  }

  @computed
  List<Widget> get todayTimeTable {
    int timetableIndex = dates[selectedDate].weekday - 1;
    List<Widget> l = [
      ...allTimetableCourses[timetableIndex].morning.map((e) => TimetableTile(course: e)),
      const TextDivider(text: 'Lunch Break'),
      ...allTimetableCourses[timetableIndex].afternoon.map((e) => TimetableTile(course: e)),
    ];
    if (l.length == 1) {
      l = [
        Center(
          child: Text(
            'No data found',
            style: OTextStyle.labelSmall.copyWith(color: OColor.gray500),
          ),
        ),
      ];
    }
    return l;
  }

  Future<void> processTimetable() async {
    //A list of timetable of each day, with index 0 to 4 signifying mon to fri
    List<TimetableDay> timetableCourses = List.generate(5, (index) => TimetableDay());

    //Lets fill the above now
    var courseList = await getCourses();
    calculateExamMode();

    const workingDays = kworkingDays;

    for (int i = 0; i <= 4; i++) {
      final day = workingDays[i];
      for (var course in courseList.courses!) {
        CourseModel copyCourse = CourseModel.clone(course);
        final timings = copyCourse.timings ?? {};
        if (timings.containsKey(day)) {
          var time = (timings[day] as String);
          if (isMorning(time)) {
            timetableCourses[i].addMorning(copyCourse);
          } else {
            timetableCourses[i].addAfternoon(copyCourse);
          }
        }
      }
      timetableCourses[i].morning.sort((a, b) {
        int t1 = int.parse(a.timings![workingDays[i]].toString().split(':')[0]);
        int t2 = int.parse(b.timings![workingDays[i]].toString().split(':')[0]);

        return t1.compareTo(t2);
      });
      timetableCourses[i].afternoon.sort((a, b) {
        int t1 = int.parse(a.timings![workingDays[i]].toString().split(':')[0]);
        int t2 = int.parse(b.timings![workingDays[i]].toString().split(':')[0]);
        return t1.compareTo(t2);
      });
    }
    allTimetableCourses = timetableCourses;
  }
}
