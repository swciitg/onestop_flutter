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

  CourseModel.clone(CourseModel c)
      : this(
            code: c.code,
            course: c.course,
            ltpc: c.ltpc,
            slot: c.slot,
            instructor: c.instructor);
}
