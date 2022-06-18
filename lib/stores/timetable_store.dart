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
  ObservableFuture<RegisteredCourses?> loadOperation =
      ObservableFuture.value(null);

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
        print("FULFILLED REACITON = ${processTimetable()}");
      }
    });
  }

  // List<TimetableDay>
  List<Map<int, List<List<String>>>> processTimetable() {
    Map<int, List<List<String>>> Data1 = {};
    Map<int, List<List<String>>> Data2 = {};
    List<Map<int, List<List<String>>>> ans = [];
    loadOperation.value!.courses!.sort((a, b) => a.slot!.compareTo(b.slot!));
    List<List<String>> a1 = [];
    List<List<String>> a2 = [];
    List<List<String>> a3 = [];
    List<List<String>> a4 = [];
    List<List<String>> a5 = [];
    List<List<String>> a11 = [];
    List<List<String>> a21 = [];
    List<List<String>> a31 = [];
    List<List<String>> a41 = [];
    List<List<String>> a51 = [];
    List<TimetableDay> timetableCourses = List.generate(5, (index) => new TimetableDay());
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
              print("List of courses = ${timetableCourses[2].toString()} adn v= $i: ${v.toString()}");
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
          switch(i) {
            case 3:
            case 4:
              v.timing = '11:00 - 11:55 AM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (slot == 'F') {
          switch(i) {
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
          switch(i) {
            case 3:
            case 4:
            case 5:
              v.timing = '12:00 - 12:55 PM';
              timetableCourses[i].addMorning(v);
              break;
          }
        }
        if (i == 1 && v.slot == 'A')
          a1.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'B')
          a1.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'D')
          a1.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'F')
          a1.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'A1')
          a11.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'B1')
          a11.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'D1')
          a11.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'F1')
          a11.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 2 && v.slot == 'A')
          a2.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'C')
          a2.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'D')
          a2.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'F')
          a2.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'A1')
          a21.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'C1')
          a21.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'D1')
          a21.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'F1')
          a21.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 3 && v.slot == 'A')
          a3.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'C')
          a3.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'E')
          a3.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'G')
          a3.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'A1')
          a31.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'C1')
          a31.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'E1')
          a31.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'G1')
          a31.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 4 && v.slot == 'B')
          a4.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'C')
          a4.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'E')
          a4.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'G')
          a4.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'B1')
          a41.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'C1')
          a41.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'E1')
          a41.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'G1')
          a41.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 5 && v.slot == 'B')
          a5.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'D')
          a5.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'F')
          a5.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'G')
          a5.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'B1')
          a51.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'D1')
          a51.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'F1')
          a51.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'G1')
          a51.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);
      }
    }
    Data1.addAll({1: a1});
    Data1.addAll({2: a2});
    Data1.addAll({3: a3});
    Data1.addAll({4: a4});
    Data1.addAll({5: a5});

    Data2.addAll({1: a11});
    Data2.addAll({2: a21});
    Data2.addAll({3: a31});
    Data2.addAll({4: a41});
    Data2.addAll({5: a51});
    ans.add(Data1);
    ans.add(Data2);
    return ans;
  }
}
