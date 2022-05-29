class Time {
  String? rollNumber;
  List<Courses>? courses;

  Time({this.rollNumber, this.courses});

  Time.fromJson(Map<String, dynamic> json) {
    rollNumber = json['roll_number'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(new Courses.fromJson(v));
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

class Courses {
  String? code;
  String? course;
  String? ltpc;
  String? slot;
  String? instructor;

  Courses({this.code, this.course, this.ltpc, this.slot, this.instructor});

  Courses.fromJson(Map<String, dynamic> json) {
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
}
