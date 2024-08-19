// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/class_timings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/working_days.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/models/timetable/timetable_day.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/timetable/timetable_tile.dart';
import 'package:onestop_dev/widgets/ui/text_divider.dart';
import 'package:onestop_kit/onestop_kit.dart';

part 'timetable_store.g.dart';

class TimetableStore = _TimetableStore with _$TimetableStore;

abstract class _TimetableStore with Store {
  //List of time table of each day of the week
  List<TimetableDay> allTimetableCourses =
      List.generate(5, (index) => TimetableDay());

  @observable
  bool isProcessed = false;

  @observable
  RegisteredCourses? courses;

  Future<RegisteredCourses> getCourses() async {
    courses ??=
        await DataProvider.getTimeTable(roll: LoginStore.userData['rollNo']);
    return courses!;
  }

  initialiseTT() async {
    if (!isProcessed) {
      initialiseDates();
      await processTimetable();
      isProcessed = true;
    }
    return "Success";
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
  int selectedDay = (DateTime.now().weekday == 6 || DateTime.now().weekday == 7)
      ? 0
      : DateTime.now().weekday - 1;

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

  List<Widget> get homeTimeTable {
    DateTime current = DateTime.now();
    String day = DateFormat.EEEE().format(DateTime.now());
    if (current.weekday == 6 || current.weekday == 7) {
      CourseModel noClass = CourseModel();
      noClass.instructor = '';
      noClass.course = 'Happy Weekend !';
      noClass.timings = {
        day: "",
      };
      return List.filled(1, TimetableTile(course: noClass));
    }
    current = dates[0];
    DateFormat dateFormat = DateFormat("hh:00 - hh:55 a");
    List<Widget> l = [
      ...allTimetableCourses[current.weekday - 1]
          .morning
          .where((e) =>
              dateFormat.parse(e.timings![day]).hour >= DateTime.now().hour)
          .toList()
          .map((e) => TimetableTile(
                course: e,
                inHomePage: true,
              ))
          .toList(),
      ...allTimetableCourses[current.weekday - 1]
          .afternoon
          .where((e) =>
              dateFormat.parse(e.timings![day]).hour >= DateTime.now().hour)
          .toList()
          .map((e) => TimetableTile(
                course: e,
                inHomePage: true,
              ))
          .toList()
    ];
    if (l.isEmpty) {
      CourseModel noClass = CourseModel();
      noClass.instructor = '';
      noClass.course = 'No upcoming classes';
      noClass.timings = {
        day: "",
      };
      l.add(TimetableTile(course: noClass));
    }
    return l;
  }

  @computed
  List<Widget> get todayTimeTable {
    int timetableIndex = dates[selectedDate].weekday - 1;
    List<Widget> l = [
      ...allTimetableCourses[timetableIndex]
          .morning
          .map((e) => TimetableTile(course: e))
          .toList(),
      const TextDivider(
        text: 'Lunch Break',
      ),
      ...allTimetableCourses[timetableIndex]
          .afternoon
          .map((e) => TimetableTile(course: e))
          .toList()
    ];
    if (l.length == 1) {
      l = [
        Center(
          child: Text(
            'No data found',
            style: MyFonts.w500.size(14).setColor(kGrey8),
          ),
        )
      ];
    }
    return l;
  }

  Future<void> processTimetable() async {
    //A list of timetable of each day, with index 0 to 4 signifying mon to fri
    List<TimetableDay> timetableCourses =
        List.generate(5, (index) => TimetableDay());

    //Lets fill the above now
    var courseList = await getCourses();

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
