import 'package:intl/intl.dart';

class CourseModel implements Comparable<CourseModel> {
  String? code;
  String? course;
  String? ltpc;
  String? slot;
  String? instructor;
  String? venue;
  String timing = "";

  CourseModel(
      {this.code,
      this.course,
      this.ltpc,
      this.slot,
      this.instructor,
      this.venue});

  CourseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    course = json['course'];
    ltpc = json['ltpc'];
    slot = json['slot'];
    instructor = json['instructor'];
    venue = json['venue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['course'] = course;
    data['ltpc'] = ltpc;
    data['slot'] = slot;
    data['instructor'] = instructor;
    return data;
  }

  @override
  String toString() {
    return "$timing : $course";
  }

  String get startTime {
    List<String> l = timing.split(' ');
    List<String> startList = [l.first, l.last];
    return startList.join(' ');
  }

  CourseModel.clone(CourseModel c)
      : this(
            code: c.code,
            course: c.course,
            ltpc: c.ltpc,
            slot: c.slot,
            instructor: c.instructor,
            venue: c.venue);

  @override
  int compareTo(CourseModel other) {
    DateFormat df = DateFormat.jm();
    DateTime curr = df.parse(startTime);
    DateTime oth = df.parse(other.startTime);
    return curr.compareTo(oth);
  }
}
