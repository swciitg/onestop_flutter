import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/home_shimmer.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DateExam extends StatefulWidget {
  final VoidCallback moveToTimeTableView;
  const DateExam({super.key, required this.moveToTimeTableView});

  @override
  State<DateExam> createState() => _DateExamState();
}

class _DateExamState extends State<DateExam> {
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

  // String _getFormattedDate(DateTime date) {
  //   String day = date.day.toString();
  //   String suffix = 'TH';
  //   if (day.endsWith('1') && day != '11') {
  //     suffix = 'ST';
  //   } else if (day.endsWith('2') && day != '12') {
  //     suffix = 'ND';
  //   } else if (day.endsWith('3') && day != '13') {
  //     suffix = 'RD';
  //   }

  //   String month = DateFormat('MMMM').format(date).toUpperCase();
  //   return '$day$suffix $month';
  // }

  DateTime? _getExamDate(CourseModel course, BuildContext context) {
    var store = context.read<TimetableStore>();
    if (store.courses == null || store.courses!.courses == null) return null;

    DateTime now = DateTime.now();
    bool isMidsemDone = true;
    List<CourseModel> validMidsems = List.from(store.courses!.courses!);
    validMidsems.removeWhere((e) => e.midsem == null || e.midsem == '');
    if (validMidsems.isNotEmpty) {
      validMidsems.sort((a, b) => DateTime.parse(a.midsem!).compareTo(DateTime.parse(b.midsem!)));
      if (DateTime.parse(validMidsems.last.midsem!).isAfter(now)) {
        isMidsemDone = false;
      }
    }

    if (!isMidsemDone) {
      if (course.midsem != null && course.midsem!.isNotEmpty) {
        return DateTime.parse(course.midsem!);
      }
    } else {
      if (course.endsem != null && course.endsem!.isNotEmpty) {
        return DateTime.parse(course.endsem!);
      }
    }
    return null;
  }

  String? _getExamVenue(CourseModel course, BuildContext context) {
    var store = context.read<TimetableStore>();
    if (store.courses == null || store.courses!.courses == null) return null;
    DateTime now = DateTime.now();
    bool isMidsemDone = true;
    List<CourseModel> validMidsems = List.from(store.courses!.courses!);
    validMidsems.removeWhere((e) => e.midsem == null || e.midsem == '');
    if (validMidsems.isNotEmpty) {
      validMidsems.sort((a, b) => DateTime.parse(a.midsem!).compareTo(DateTime.parse(b.midsem!)));
      if (DateTime.parse(validMidsems.last.midsem!).isAfter(now)) {
        isMidsemDone = false;
      }
    }
    return !isMidsemDone ? course.midsemVenue : course.endsemVenue;
  }

  String _getNextExamTime(CourseModel course, BuildContext context) {
    DateTime? examDate = _getExamDate(course, context);
    if (examDate == null) return '';

    DateTime now = DateTime.now();
    Duration difference = examDate.difference(now);

    if (difference.isNegative) {
      if (difference.inHours.abs() < 3) return 'Going on';
      return 'Finished';
    }

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    if (days > 0) {
      return '$days ${days == 1 ? 'day' : 'days'}';
    } else if (hours > 0) {
      return '$hours ${hours == 1 ? 'hr' : 'hrs'} ${minutes > 0 ? '$minutes min' : ''}';
    } else if (minutes > 0) {
      return '$minutes ${minutes == 1 ? 'min' : 'mins'}';
    } else {
      return 'Starting now';
    }
  }

  Widget _buildClassCard(CourseModel course, BuildContext context) {
    DateTime? dateTime = _getExamDate(course, context);
    String displayTime = dateTime != null ? DateFormat('dd MMM, hh:mm a').format(dateTime) : '';
    String? venue = _getExamVenue(course, context);

    return Container(
      height: 100,
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: OColor.gray100, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.clock_16_regular, size: 14, color: OColor.gray600),
                  const SizedBox(width: 4),
                  OText(
                    text: displayTime,
                    style: OTextStyle.labelSmall.copyWith(
                      color: OColor.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          OText(
            text: '${course.code ?? ''} - ${course.course ?? ''}',
            style: OTextStyle.bodySmall.copyWith(color: OColor.black, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (venue != null && venue.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(FluentIcons.location_20_regular, size: 12, color: OColor.gray600),
                const SizedBox(width: 4),
                Expanded(
                  child: OText(
                    text: venue,
                    style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            var store = context.read<TimetableStore>();
            var classes = store.homeUpcomingExams;
            if (classes.isEmpty) return const SizedBox();

            var nextClass = classes.first;
            var otherClasses = classes.skip(1).toList();
            String examType = store.upcomingExamType;
            String? nextVenue = _getExamVenue(nextClass, context);
            DateTime? nextDateTime = _getExamDate(nextClass, context);
            String nextDisplayTime =
                nextDateTime != null ? DateFormat('dd MMM, hh:mm a').format(nextDateTime) : '';

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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/timetable.svg",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OText(
                                  text: examType,
                                  style: OTextStyle.headingSmall.copyWith(
                                    color: OColor.black,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                          const SizedBox(height: 4),
                          Builder(
                            builder: (context) {
                              final timeText = _getNextExamTime(nextClass, context);
                              final bool isOngoing =
                                  timeText == 'Going on' || timeText == 'Starting now';
                              final bool isFinished = timeText == 'Finished';
                              return Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        OText(
                                          text:
                                              isOngoing
                                                  ? 'Exam '
                                                  : isFinished
                                                  ? 'Exam '
                                                  : 'Exam in ',
                                          style: OTextStyle.headingLarge.copyWith(
                                            color: OColor.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Expanded(
                                          child: OText(
                                            text: timeText,
                                            style: OTextStyle.headingLarge.copyWith(
                                              color: OColor.red600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          OText(
                            text:
                                (nextClass.code != null && nextClass.code!.isNotEmpty)
                                    ? '${nextClass.code} - ${nextClass.course ?? ''}'
                                    : (nextClass.course ?? ''),
                            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(FluentIcons.clock_16_regular, size: 14, color: OColor.gray600),
                              const SizedBox(width: 4),
                              OText(
                                text: nextDisplayTime,
                                style: OTextStyle.labelMedium.copyWith(
                                  color: OColor.gray700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (nextVenue != null && nextVenue.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Icon(
                                  FluentIcons.location_16_regular,
                                  size: 14,
                                  color: OColor.gray600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: OText(
                                    text: nextVenue,
                                    style: OTextStyle.labelMedium.copyWith(
                                      color: OColor.gray700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (otherClasses.isNotEmpty) ...[
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(otherClasses.length, (index) {
                                      final course = otherClasses[index];
                                      final first = index == 0;
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: first ? 16 : 8,
                                          right: index == otherClasses.length - 1 ? 16 : 0,
                                          bottom: 16,
                                        ),
                                        child: _buildClassCard(course, context),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
