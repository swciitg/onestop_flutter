import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/home_shimmer.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DateCourse extends StatefulWidget {
  final VoidCallback moveToTimeTableView;
  const DateCourse({super.key, required this.moveToTimeTableView});

  @override
  State<DateCourse> createState() => _DateCourseState();
}

class _DateCourseState extends State<DateCourse> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getFormattedDate(DateTime date) {
    // Get day with suffix (1st, 2nd, 3rd, 4th, etc.)
    String day = date.day.toString();
    String suffix = 'TH';
    if (date.day % 10 == 1 && date.day != 11) {
      suffix = 'ST';
    } else if (date.day % 10 == 2 && date.day != 12) {
      suffix = 'ND';
    } else if (date.day % 10 == 3 && date.day != 13) {
      suffix = 'RD';
    }

    // Get month name in uppercase
    String month = DateFormat('MMMM').format(date).toUpperCase();

    return '$day$suffix $month';
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    context.read<TimetableStore>().initialiseDates();

    return Observer(
      builder: (context) {
        return FutureBuilder(
          future: context.read<TimetableStore>().initialiseTT(),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              if (snapshot.hasError) {
                log("Something went wrong : ${snapshot.error}");
              }
              return const HomeTimetableShimmer();
            }
            var classes = context.read<TimetableStore>().homeTimeTable;
            if (classes.isEmpty) return SizedBox();

            // Get next class (first in the list)
            var nextClass = classes.first;
            var otherClasses = classes.skip(1).toList();

            return GestureDetector(
              onTap: widget.moveToTimeTableView,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: OColor.white,
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                  border: Border.all(color: OColor.gray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with calendar icon, title and date
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/timetable.svg",
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Row(
                                  children: [
                                    OText(
                                      text: 'Time Table',
                                      style: OTextStyle.headingSmall.copyWith(
                                        color: OColor.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OText(
                                      text: '•',
                                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
                                    ),
                                    const SizedBox(width: 8),
                                    OText(
                                      text: _getFormattedDate(now),
                                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(16, 0),
                                child: IconButton(
                                  onPressed: widget.moveToTimeTableView,
                                  icon: Icon(
                                    FluentIcons.chevron_right_24_regular,
                                    color: OColor.gray400,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Next class section
                          if (nextClass.course != 'No upcoming classes' &&
                              nextClass.course != 'Happy Weekend !') ...[
                            Builder(
                              builder: (context) {
                                final timeText = _getNextClassTime(nextClass);
                                final bool isOngoing =
                                    timeText == 'Started' || timeText == 'Running now';
                                return Row(
                                  children: [
                                    OText(
                                      text: isOngoing ? 'Class ' : 'Class in ',
                                      style: OTextStyle.headingLarge.copyWith(
                                        color: OColor.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    OText(
                                      text: isOngoing ? 'Ongoing' : timeText,
                                      style: OTextStyle.headingLarge.copyWith(
                                        color: OColor.green600,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            OText(
                              text: '${nextClass.code ?? ''} - ${nextClass.course ?? ''}',
                              style: OTextStyle.bodyMedium.copyWith(color: OColor.gray600),
                            ),
                          ] else ...[
                            // No classes or weekend message
                            Center(
                              child: OText(
                                text: nextClass.course ?? 'No upcoming classes',
                                style: OTextStyle.headingLarge.copyWith(
                                  color:
                                      nextClass.course == 'Happy Weekend !'
                                          ? OColor.green500
                                          : OColor.gray600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Other classes in horizontal list
                    if (otherClasses.isNotEmpty) ...[
                      Stack(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(otherClasses.length, (index) {
                                final course = otherClasses[index];
                                final first = index == 0;
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ).copyWith(right: first ? 0 : 12),
                                  child: _buildClassCard(course),
                                );
                              }),
                            ),
                          ),
                          // Fade gradient on the right
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    OColor.white.withValues(alpha: 0.0),
                                    OColor.white.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getNextClassTime(dynamic course) {
    if (course.timings == null || course.timings!.isEmpty) return '';

    String day = DateFormat.EEEE().format(DateTime.now());
    String? timing = course.timings![day];

    if (timing == null || timing.isEmpty) return '';

    try {
      // Use the same DateFormat as in TimetableStore
      DateFormat dateFormat = DateFormat("hh:00 - hh:55 a");
      DateTime now = DateTime.now();
      DateTime classTime = dateFormat.parse(timing);

      // Create today's class time
      DateTime todayClassTime = DateTime(
        now.year,
        now.month,
        now.day,
        classTime.hour,
        classTime.minute,
      );

      // Calculate time difference
      Duration difference = todayClassTime.difference(now);

      if (difference.isNegative) {
        return 'Started';
      }

      // Format the remaining time
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;

      if (hours > 0) {
        String hourText = hours == 1 ? 'hr' : 'hrs';
        String minuteText = minutes == 1 ? 'min' : 'mins';
        return '$hours $hourText ${minutes > 0 ? '$minutes $minuteText' : ''}';
      } else if (minutes > 0) {
        String minuteText = minutes == 1 ? 'min' : 'mins';
        return '$minutes $minuteText';
      } else {
        return 'Running now';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildClassCard(CourseModel course) {
    String day = DateFormat.EEEE().format(DateTime.now());
    String timing = course.timings?[day] ?? '';
    DateTime dateTime = DateFormat('hh:00 - hh:55 a').parse(timing);
    String displayTime = DateFormat('hh:mm a').format(dateTime);
    return Container(
      height: 90, // Safe height
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: OColor.gray100, borderRadius: BorderRadius.circular(8)),
      constraints: BoxConstraints(maxWidth: 180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OText(
            text: displayTime,
            style: OTextStyle.labelSmall.copyWith(
              color: OColor.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          OText(
            text: '${course.code ?? ''} - ${course.course ?? ''}',
            style: OTextStyle.bodySmall.copyWith(color: OColor.black, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
