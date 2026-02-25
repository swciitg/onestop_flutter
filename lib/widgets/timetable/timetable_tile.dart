import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/timetable/time_range.dart';
import 'package:onestop_dev/globals/working_days.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Event Card for timetable — matches Figma design.
///
/// White card with gray border, green accent bar on the left,
/// course name, instructor, and code/venue info.
class TimetableTile extends StatelessWidget {
  final CourseModel course;
  final bool inHomePage;

  const TimetableTile({super.key, required this.course, this.inHomePage = false});

  @override
  Widget build(BuildContext context) {
    TimetableStore ttStore = context.read<TimetableStore>();
    final dayIndex = ttStore.selectedDay;
    final DateTime selectedDateTime = ttStore.dates[ttStore.selectedDate];

    final String currentTimeString = findTimeRange();
    final String? dayTiming = course.timings?[kworkingDays[dayIndex]]?.toString();

    final bool isNow =
        dayTiming != null &&
        currentTimeString == dayTiming &&
        (inHomePage || selectedDateTime.weekday == DateTime.now().weekday);

    final String timing = dayTiming ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: OSpacing.xxs),
      child: Container(
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: isNow ? OColor.green600 : OColor.gray200),
        ),
        padding: const EdgeInsets.all(OSpacing.s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green accent bar
            Container(
              width: 3,
              height: 48,
              margin: const EdgeInsets.only(right: OSpacing.s),
              decoration: BoxDecoration(
                color: isNow ? OColor.green600 : OColor.gray400,
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
                  // Instructor and code
                  Row(
                    children: [
                      if (course.instructor != null && course.instructor!.isNotEmpty)
                        Flexible(
                          child: Text(
                            course.instructor!,
                            style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (course.code != null && course.code!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: OSpacing.xs),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: OColor.gray400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(
                          course.code!,
                          style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                        ),
                      ],
                    ],
                  ),
                  // Timing and venue row
                  if (timing.isNotEmpty || (course.venue != null && course.venue!.isNotEmpty)) ...[
                    const SizedBox(height: OSpacing.xxs),
                    Row(
                      children: [
                        if (timing.isNotEmpty)
                          Text(
                            timing,
                            style: OTextStyle.labelXSmall.copyWith(color: OColor.gray400),
                          ),
                        if (timing.isNotEmpty && course.venue != null && course.venue!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: OSpacing.xs),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: OColor.gray400,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        if (course.venue != null && course.venue!.isNotEmpty)
                          Flexible(
                            child: Text(
                              course.venue!,
                              style: OTextStyle.labelXSmall.copyWith(color: OColor.gray400),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
