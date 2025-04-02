import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class ExamTile extends StatelessWidget {
  final bool isEndSem;
  final CourseModel course;

  const ExamTile({super.key, required this.course, this.isEndSem = false});

  String formatTime(String time, String type) {
    DateTime examTime = DateTime.parse(time);
    if (type == "date") {
      return examTime.day.toString();
    }
    if (type == "month") {
      return DateFormat.MMM().format(examTime);
    }
    if (type == "time") {
      return "${DateFormat.jm().format(examTime)} - ${DateFormat.jm().format(examTime.add(Duration(hours: isEndSem ? 3 : 2)))}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    String time = isEndSem ? course.endsem! : course.midsem!;
    String? venue = isEndSem ? course.endsemVenue : course.midsemVenue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 85),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: kTimetableGreen,
            border: Border.all(color: Colors.transparent),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatTime(time, "month"),
                                  style: MyFonts.w400.setColor(kWhite),
                                ),
                                Text(
                                  formatTime(time, "date"),
                                  style: MyFonts.w400.setColor(kWhite).size(30),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(time, "time"),
                        style: MyFonts.w300.size(12).setColor(kWhite),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        course.course!,
                        style: MyFonts.w500.size(15).setColor(kWhite),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(minWidth: 70),
                            child: Text(
                              course.code!,
                              style: MyFonts.w400.size(13).setColor(lBlue),
                            ),
                          ),
                          if (venue != null && venue.isNotEmpty)
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    FluentIcons.location_12_filled,
                                    color: lBlue,
                                    size: 13,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      venue,
                                      style:
                                          MyFonts.w400.size(13).setColor(lBlue),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
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
