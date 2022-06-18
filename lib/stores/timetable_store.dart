import 'package:mobx/mobx.dart';
import 'package:onestop_dev/models/timetable.dart';
import 'package:onestop_dev/services/api.dart';

part 'timetable_store.g.dart';

class TimetableStore = _TimetableStore with _$TimetableStore;

abstract class _TimetableStore with Store {
  List<DateTime> dates = List.filled(5, DateTime.now());

  _TimetableStore() {
    setupReactions();
    if (dates[0].weekday == 6 || dates[0].weekday == 7) {
      while (dates[0].weekday != 1) {
        dates[0] = dates[0].add(Duration(days: 1));
      }
    }
    for (int i = 1; i < 5; i++) {
      dates[i] = dates[i - 1].add(Duration(days: 1));
      if (dates[i].weekday == 6) {
        dates[i] = dates[i].add(Duration(days: 2));
      }
    }
  }

  @observable
  ObservableFuture<RegisteredCourses?> loadOperation = ObservableFuture.value(null);
  int index = 0;

  @observable
  int selectedDate = 0;



  @action
  void setDate(int i) {
    selectedDate = i;
  }


  @action
  Future<void> setTimetable(String rollNumber) async {
    print("First API call ${loadOperation.status}");
    if (loadOperation.value == null) {
      loadOperation = APIService.getTimeTable(roll: rollNumber).asObservable();
    }
  }

  @computed
  bool get coursesLoaded => loadOperation.value != null;

  @computed
  bool get coursesLoading =>
      loadOperation.value == null ||
          loadOperation.status == FutureStatus.pending;

  @computed
  bool get coursesError => loadOperation.status == FutureStatus.rejected;

  void setupReactions() {
    autorun((_) {
      print("RAN REACTION YAY ${loadOperation.status}");
      if (loadOperation.status == FutureStatus.fulfilled) {
      }
    });
  }

  @observable
  List<TimetableDay> allTimetableCourses = List.generate(
      5, (index) => new TimetableDay());

  @action
  void processTimetable() {
    loadOperation.value!.courses!.sort((a, b) => a.slot!.compareTo(b.slot!));
    List<TimetableDay> timetableCourses = List.generate(
        5, (index) => new TimetableDay());
    for (int i = 1; i <= 5; i++) {
      for (var v in loadOperation.value!.courses!) {
        String slot = v.slot!;
        if (slot == 'A') {
          switch (i) {
            case 1:
            case 2:
            case 3:
              v.timing = '09:00 - 09:55 AM';
              timetableCourses[i].addMorning(v);
              print("List of courses = ${timetableCourses[2]
                  .toString()} adn v= $i: ${v.toString()}");
              break;
          }
        }
        if (slot == 'B') {
          switch (i) {
            case 4:
            case 5:
              v.timing = '09:00 - 09:55 AM';
              timetableCourses[i].addMorning(v);
              break;
            case 1:
              v.timing = '10:00 - 10:55 AM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'C') {
          switch (i) {
            case 2:
            case 3:
            case 4:
              v.timing = '10:00 - 10:55 AM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'D') {
          switch (i) {
            case 5:
              v.timing = '10:00 - 10:55 AM';
              timetableCourses[i].addMorning(v);
              break;
            case 1:
            case 2:
              v.timing = '11:00 - 11:55 AM';
              timetableCourses[i].addMorning(v);
          }
        }
        if (slot == 'E') {
          switch (i) {
            case 3:
            case 4:
              v.timing = '11:00 - 11:55 AM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'F') {
          switch (i) {
            case 1:
            case 2:
              v.timing = '12:00 - 12:55 PM';
              timetableCourses[i].addMorning(v);
              break;
            case 5:
              v.timing = '11:00 - 11:55 AM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'G') {
          switch (i) {
            case 3:
            case 4:
            case 5:
              v.timing = '12:00 - 12:55 PM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'A1') {
          switch (i) {
            case 1:
            case 2:
            case 3:
              v.timing = '02:00 - 02:55 PM';
              timetableCourses[i].addAfternoon(v);
              print("List of courses = ${timetableCourses[2]
                  .toString()} adn v= $i: ${v.toString()}");
              break;
          }
        }
        if (slot == 'B1') {
          switch (i) {
            case 4:
            case 5:
              v.timing = '02:00 - 02:55 PM';
              timetableCourses[i].addAfternoon(v);
              break;
            case 1:
              v.timing = '03:00 - 03:55 PM';
              timetableCourses[i].addAfternoon(v);
              break;
          }
        }
        if (slot == 'C1') {
          switch (i) {
            case 2:
            case 3:
            case 4:
              v.timing = '03:00 - 03:55 AM';
              timetableCourses[i].addAfternoon(v);
              break;
          }
        }
        if (slot == 'D1') {
          switch (i) {
            case 5:
              v.timing = '03:00 - 03:55 PM';
              timetableCourses[i].addMorning(v);
              break;
            case 1:
            case 2:
              v.timing = '04:00 - 04:55 PM';
              timetableCourses[i].addMorning(v);
          }
        }
        if (slot == 'E1') {
          switch (i) {
            case 3:
            case 4:
              v.timing = '04:00 - 04:55 AM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'F1') {
          switch (i) {
            case 1:
            case 2:
              v.timing = '05:00 - 05:55 PM';
              timetableCourses[i].addMorning(v);
              break;
            case 5:
              v.timing = '04:00 - 04:55 AM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'G1') {
          switch (i) {
            case 3:
            case 4:
            case 5:
              v.timing = '05:00 - 05:55 PM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
      }
    }
    allTimetableCourses= timetableCourses;
  }

  @computed
  TimetableDay get todayTimeTable=>allTimetableCourses[selectedDate];
}
