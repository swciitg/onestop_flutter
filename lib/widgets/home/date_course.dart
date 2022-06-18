import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/timetable/time_range.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/timetable/home_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class DateCourse extends StatefulWidget {
  const DateCourse({
    Key? key,
  }) : super(key: key);

  @override
  State<DateCourse> createState() => _DateCourseState();
}

class _DateCourseState extends State<DateCourse> {

  @override
  Widget build(BuildContext context) {
    return HomeTimetableShimmer();
  }
}
