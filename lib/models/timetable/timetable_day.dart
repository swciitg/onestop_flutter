import 'package:onestop_dev/models/timetable/course_model.dart';

class TimetableDay {
  List<CourseModel> morning = [];
  List<CourseModel> afternoon = [];

  void addMorning(CourseModel c)
  {
    if(c.timing == '08:00 - 08:55 AM')
      {
        morning.insert(0, c);
      }
    else
      {
        morning.add(c);
      }
  }
  //void addFirstMorning(CourseModel c) => morning.insert(0,c);
  void addAfternoon(CourseModel c) => afternoon.add(c);

  @override
  String toString() {
    return "Morning: ${morning.map((e) => e.toString())} | Noon: ${afternoon.map((e) => e.toString())}";
  }
}
