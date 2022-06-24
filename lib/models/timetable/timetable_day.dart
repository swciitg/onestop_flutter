import 'package:onestop_dev/models/timetable/course_model.dart';

class TimetableDay {
  List<CourseModel> morning = [];
  List<CourseModel> afternoon = [];

  void addMorning(CourseModel c) => morning.add(c);
  void addAfternoon(CourseModel c) => afternoon.add(c);

  String toString() {
    return "Morning: ${morning.map((e) => e.toString())} | Noon: ${afternoon.map((e) => e.toString())}";
  }
}
