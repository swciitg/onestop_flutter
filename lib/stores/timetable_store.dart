// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/models/timetable/timetable_day.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/ui/text_divider.dart';
import 'package:onestop_dev/widgets/timetable/timetable_tile.dart';

part 'timetable_store.g.dart';

class TimetableStore = _TimetableStore with _$TimetableStore;

abstract class _TimetableStore with Store {
  _TimetableStore() {
    setupReactions();
    initialiseDates();
  }

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

  List<DateTime> dates = List.filled(5, DateTime.now());

  List<TimetableDay> allTimetableCourses =
      List.generate(5, (index) => TimetableDay());

  @observable
  ObservableFuture<RegisteredCourses?> loadOperation =
      ObservableFuture.value(null);

  @observable
  int selectedDate = 0;

  @action
  void setDate(int i) {
    selectedDate = i;
  }

  @observable
  bool showDropDown = false;

  @action
  Future<void> setTimetable(String rollNumber,BuildContext context) async {
    if (loadOperation.value == null) {
      loadOperation =
          DataProvider.getTimeTable(roll: rollNumber).asObservable();
    }
  }

  @action
  void toggleDropDown() {
    showDropDown = !showDropDown;
  }

  @action
  void setDropDown(bool b) {
    showDropDown = b;
  }

  @computed
  bool get coursesLoaded => loadOperation.value != null;

  @computed
  bool get coursesLoading =>
      loadOperation.value == null ||
      loadOperation.status == FutureStatus.pending;

  @computed
  bool get coursesError => loadOperation.status == FutureStatus.rejected;

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

  List<Widget> get homeTimeTable {
    DateTime current = DateTime.now();
    if (current.weekday == 6 || current.weekday == 7) {
      CourseModel noClass = CourseModel();
      noClass.instructor = '';
      noClass.course = 'Happy Weekend !';
      noClass.timing = '';
      return List.filled(1, TimetableTile(course: noClass));
    }
    current = dates[0];
    DateFormat dateFormat = DateFormat("hh:00 - hh:55 a");
    List<Widget> l = [
      ...allTimetableCourses[current.weekday - 1]
          .morning
          .where((e) => dateFormat.parse(e.timing).hour >= DateTime.now().hour)
          .toList()
          .map((e) => TimetableTile(
                course: e,
                inHomePage: true,
              ))
          .toList(),
      ...allTimetableCourses[current.weekday - 1]
          .afternoon
          .where((e) => dateFormat.parse(e.timing).hour >= DateTime.now().hour)
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
      noClass.timing = '';
      l.add(TimetableTile(course: noClass));
    }
    return l;
  }

  void setupReactions() {
    autorun((_) {
      if (loadOperation.value != null) {
        processTimetable();
      }
    });
  }

  void processTimetable() {
    List<TimetableDay> timetableCourses =
        List.generate(5, (index) => TimetableDay());
    var courseList = loadOperation.value!;
    for (int i = 0; i <= 4; i++) {
      for (var v in courseList.courses!) {
        String slot = v.slot!;
        CourseModel copyCourse = CourseModel.clone(v);
        if (slot == 'A') {
          switch (i) {
            case 0:
            case 1:
            case 2:
              copyCourse.timing = '09:00 - 09:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'B') {
          switch (i) {
            case 3:
            case 4:
              copyCourse.timing = '09:00 - 09:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
            case 0:
              copyCourse.timing = '10:00 - 10:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'C') {
          switch (i) {
            case 1:
            case 2:
            case 3:
              copyCourse.timing = '10:00 - 10:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'D') {
          switch (i) {
            case 4:
              copyCourse.timing = '10:00 - 10:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
            case 0:
            case 1:
              copyCourse.timing = '11:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
          }
        }
        if (slot == 'E') {
          switch (i) {
            case 2:
            case 3:
              copyCourse.timing = '11:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'F') {
          switch (i) {
            case 0:
            case 1:
              copyCourse.timing = '12:00 - 12:55 PM';
              timetableCourses[i].addMorning(copyCourse);
              break;
            case 4:
              copyCourse.timing = '11:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'G') {
          switch (i) {
            case 2:
            case 3:
            case 4:
              copyCourse.timing = '12:00 - 12:55 PM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'A1') {
          switch (i) {
            case 0:
            case 1:
            case 2:
              copyCourse.timing = '02:00 - 02:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'B1') {
          switch (i) {
            case 3:
            case 4:
              copyCourse.timing = '02:00 - 02:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
            case 0:
              copyCourse.timing = '03:00 - 03:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'C1') {
          switch (i) {
            case 1:
            case 2:
            case 3:
              copyCourse.timing = '03:00 - 03:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'D1') {
          switch (i) {
            case 4:
              copyCourse.timing = '03:00 - 03:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
            case 0:
            case 1:
              copyCourse.timing = '04:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'E1') {
          switch (i) {
            case 2:
            case 3:
              copyCourse.timing = '04:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'F1') {
          switch (i) {
            case 0:
            case 1:
              copyCourse.timing = '05:00 - 05:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
            case 4:
              copyCourse.timing = '04:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'G1') {
          switch (i) {
            case 2:
            case 3:
            case 4:
              copyCourse.timing = '05:00 - 05:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'c') {
          switch (i) {
            case 0:
              copyCourse.timing = '08:00 - 08:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'e') {
          switch (i) {
            case 1:
              copyCourse.timing = '08:00 - 08:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'b') {
          switch (i) {
            case 2:
              copyCourse.timing = '08:00 - 08:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'd') {
          switch (i) {
            case 3:
              copyCourse.timing = '08:00 - 08:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'a') {
          switch (i) {
            case 4:
              copyCourse.timing = '08:00 - 08:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'ML1') {
          switch (i) {
            case 0:
              copyCourse.timing = '09:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'ML2') {
          switch (i) {
            case 1:
              copyCourse.timing = '09:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'ML3') {
          switch (i) {
            case 2:
              copyCourse.timing = '09:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }

        if (slot == 'ML4') {
          switch (i) {
            case 3:
              copyCourse.timing = '09:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'ML5') {
          switch (i) {
            case 4:
              copyCourse.timing = '09:00 - 11:55 AM';
              timetableCourses[i].addMorning(copyCourse);
              break;
          }
        }
        if (slot == 'AL1') {
          switch (i) {
            case 0:
              copyCourse.timing = '02:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'AL2') {
          switch (i) {
            case 1:
              copyCourse.timing = '02:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'AL3') {
          switch (i) {
            case 2:
              copyCourse.timing = '02:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'AL4') {
          switch (i) {
            case 3:
              copyCourse.timing = '02:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
        if (slot == 'AL5') {
          switch (i) {
            case 4:
              copyCourse.timing = '02:00 - 04:55 PM';
              timetableCourses[i].addAfternoon(copyCourse);
              break;
          }
        }
      }
      timetableCourses[i].morning.sort(((a, b) => a.timing.compareTo(b.timing)));
      timetableCourses[i].afternoon.sort((a,b)=> a.timing.compareTo(b.timing));
    }
    allTimetableCourses = timetableCourses;
  }
}
