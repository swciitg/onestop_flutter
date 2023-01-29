import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/timetable/time_range.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:provider/provider.dart';

class TimetableTile extends StatelessWidget {
  final CourseModel course;
  final bool inHomePage;
  const TimetableTile({Key? key, required this.course, this.inHomePage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tileIcon = FluentIcons.book_24_filled;
    if (course.course!.toLowerCase().contains("lab")) {
      tileIcon = FluentIcons.beaker_24_filled;
    }
    String currentTimeString = findTimeRange();
    TimetableStore ttStore = context.read<TimetableStore>();
    DateTime selectedDateTime = ttStore.dates[ttStore.selectedDate];
    bool showHighlight = currentTimeString == course.timing &&
        selectedDateTime.weekday == DateTime.now().weekday;
    if (inHomePage) {
      showHighlight = currentTimeString == course.timing;
    }
    Color bg = showHighlight ? kTimetableGreen : kTimetableDisabled;
    if (inHomePage) bg = kTimetableGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 85),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: bg,
            border: showHighlight
                ? Border.all(color: Colors.blueAccent)
                : Border.all(color: Colors.transparent),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 10),
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kGreen,
                        ),
                        child: Icon(
                          tileIcon,
                          color: kAppBarGrey,
                          size: 25,
                        ),
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
                      Text(
                        course.instructor!,
                        style: MyFonts.w400.size(13).setColor(lBlue),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      if (course.venue != null)
                        Row(
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
                                course.venue!,
                                style: MyFonts.w400.size(13).setColor(lBlue),
                              ),
                            )
                          ],
                        )
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
