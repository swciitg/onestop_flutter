import 'package:onestop_dev/models/timetable/course_model.dart';

class RegisteredCourses {
  String? rollNumber;
  List<CourseModel>? courses;

  RegisteredCourses({this.rollNumber, this.courses});

  RegisteredCourses.fromJson(Map<String, dynamic> json) {
    rollNumber = json['roll_number'];
    if (json['courses'] != null) {
      courses = <CourseModel>[];
      json['courses'].forEach((v) {
        courses!.add(new CourseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roll_number'] = this.rollNumber;
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
