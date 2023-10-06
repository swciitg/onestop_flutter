// import 'package:intl/intl.dart';

class CourseModel /*implements Comparable<CourseModel> */ {
  String? code;
  String? course;
  String? ltpc;
  String? slot;
  String? instructor;
  String? venue;
  String? midsem;
  String? endsem;
  String? midsemVenue;
  String? endsemVenue;
  Map<String, dynamic>? timings;

  CourseModel({
    this.code,
    this.course,
    this.ltpc,
    this.slot,
    this.endsem,
    this.midsem,
    this.instructor,
    this.venue,
    this.midsemVenue,
    this.endsemVenue,
    this.timings,
  });

  CourseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    course = json['course'];
    ltpc = json['ltpc'];
    slot = json['slot'];
    instructor = json['instructor'];
    venue = json['venue'];
    midsem = json['midsem'];
    endsem = json['endsem'];
    midsemVenue = json['midsemVenue'];
    endsemVenue = json['endsemVenue'];
    timings = (json['timings'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value.toString().trim()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['course'] = course;
    data['ltpc'] = ltpc;
    data['slot'] = slot;
    data['midsem'] = midsem;
    data['endsem'] = endsem;
    data['venue'] = venue;
    data['instructor'] = instructor;
    data['midSemVenue'] = midsemVenue;
    data['endSemVenue'] = endsemVenue;
    data['timings'] = timings;
    return data;
  }

  // @override
  // String toString() {
  //   return "$timing : $course";
  // }

  // String get startTime {
  //   List<String> l = timing.split(' ');
  //   List<String> startList = [l.first, l.last];
  //   return startList.join(' ');
  // }

  CourseModel.clone(CourseModel c)
      : this(
          code: c.code,
          course: c.course,
          ltpc: c.ltpc,
          slot: c.slot,
          midsem: c.midsem,
          endsem: c.endsem,
          instructor: c.instructor,
          venue: c.venue,
          midsemVenue: c.midsemVenue,
          endsemVenue: c.endsemVenue,
          timings: c.timings,
        );

  // @override
  // int compareTo(CourseModel other) {
  //   DateFormat df = DateFormat.jm();
  //   DateTime curr = df.parse(startTime);
  //   DateTime oth = df.parse(other.startTime);
  //   return curr.compareTo(oth);
  // }
}
