import 'package:onestop_dev/models/timetable/course_model.dart';

class TimetableDay {
  List<CourseModel> morning = [];
  List<CourseModel> afternoon = [];
  static const List<String> morningClasses = [
    "8:00-9:00 AM",
    "9:00-10:00 AM",
    "10:00-11:00 AM",
    "11:00-12:00 PM",
    "12:00-1:00 PM",
  ];

  static const List<String> afternoonClasses = [
    "1:00-2:00 PM",
    "2:00-3:00 PM",
    "3:00-4:00 PM",
    "4:00-5-00 PM",
    "5:00-6:00 PM",
  ];

  void addMorning(CourseModel c) {
    // Tutorials first
    if (c.timing == '08:00 - 08:55 AM') {
      morning.insert(0, c);
    } else {
      morning.add(c);
    }
  }

  void addAfternoon(CourseModel c) => afternoon.add(c);

  @override
  String toString() {
    return "Morning: ${morning.map((e) => e.toString())} | Noon: ${afternoon.map((e) => e.toString())}";
  }
}
