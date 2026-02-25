import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_ui/index.dart';

/// Event Card for exam schedule — matches Figma design.
///
/// White card with gray border, green accent bar on the left,
/// course name, date with calendar icon, and time + venue.
class ExamTile extends StatelessWidget {
  final bool isEndSem;
  final CourseModel course;

  const ExamTile({super.key, required this.course, this.isEndSem = false});

  String _formatDate(String time) {
    final dt = DateTime.parse(time);
    return '${dt.day} ${DateFormat.MMM().format(dt)}';
  }

  String _formatTime(String time) {
    final dt = DateTime.parse(time);
    final end = dt.add(Duration(hours: isEndSem ? 3 : 2));
    return '${DateFormat.jm().format(dt)} - ${DateFormat.jm().format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final String time = isEndSem ? course.endsem! : course.midsem!;
    final String? venue = isEndSem ? course.endsemVenue : course.midsemVenue;

    // Determine whether the exam is upcoming (highlight in green)
    final DateTime examDt = DateTime.parse(time);
    final bool isUpcoming = examDt.isAfter(DateTime.now());

    return Container(
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      padding: const EdgeInsets.all(OSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green accent bar
          Container(
            width: 3,
            height: 56,
            margin: const EdgeInsets.only(right: OSpacing.s),
            decoration: BoxDecoration(
              color: isUpcoming ? OColor.green600 : OColor.gray400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course name
                Text(
                  course.course ?? '',
                  style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                ),
                const SizedBox(height: OSpacing.xxs),
                // Date row with calendar icon
                Row(
                  children: [
                    Icon(
                      FluentIcons.calendar_ltr_16_regular,
                      size: 16,
                      color: isUpcoming ? OColor.green600 : OColor.gray400,
                    ),
                    const SizedBox(width: OSpacing.xxs),
                    Text(
                      _formatDate(time),
                      style: OTextStyle.labelSmall.copyWith(
                        color: isUpcoming ? OColor.green600 : OColor.gray400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: OSpacing.xxs),
                // Time + venue row
                Row(
                  children: [
                    Text(
                      _formatTime(time),
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray400),
                    ),
                    if (venue != null && venue.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: OSpacing.xs),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(color: OColor.gray400, shape: BoxShape.circle),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          venue,
                          style: OTextStyle.labelSmall.copyWith(color: OColor.gray400),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
