

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

class CourseModel {
  String? code;
  String? course;
  String? ltpc;
  String? slot;
  String? instructor;
  String timing = "";

  CourseModel({this.code, this.course, this.ltpc, this.slot, this.instructor});

  CourseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    course = json['course'];
    ltpc = json['ltpc'];
    slot = json['slot'];
    instructor = json['instructor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['course'] = this.course;
    data['ltpc'] = this.ltpc;
    data['slot'] = this.slot;
    data['instructor'] = this.instructor;
    return data;
  }

  String toString() {
    return "$timing : $course";
  }

}

class TimetableDay {
   List<CourseModel> morning = [];
   List<CourseModel> afternoon = [];

   void addMorning(CourseModel c) => morning.add(c);
   void addAfternoon(CourseModel c) => afternoon.add(c);

   String toString() {
     return "Morning: ${morning.map((e) => e.toString())} | Noon: ${afternoon.map((e) => e.toString())}";
   }

}
