import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/timetable/time_range.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';

class TimetableTile extends StatelessWidget {
  late final CourseModel course;
  late final bool inHomePage;
  TimetableTile({Key? key, required this.course, this.inHomePage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sel = findTimeRange();
    Color bg = (sel == course.timing)
        ? kTimetableGreen
        : Color.fromRGBO(120, 120, 120, 0.16);
    if (inHomePage) bg = kTimetableGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 85),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: bg,
            border: (sel == course.timing)
                ? Border.all(color: Colors.blueAccent)
                : Border.all(color: Colors.transparent),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Image.asset('assets/images/class.png'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.timing,
                        style: MyFonts.w300.size(12).setColor(kWhite),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        course.course!,
                        style: MyFonts.w500.size(15).setColor(kWhite),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        course.instructor!,
                        style: MyFonts.w400.size(13).setColor(lBlue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
