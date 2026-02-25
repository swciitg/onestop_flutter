import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/working_days.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/date_slider.dart';
import 'package:onestop_dev/widgets/timetable/exam_schedule_tile.dart';
import 'package:onestop_dev/widgets/timetable/timetable_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class TimeTableTab extends StatefulWidget {
  static const String id = '/time';

  const TimeTableTab({super.key});

  @override
  State<TimeTableTab> createState() => _TimeTableTabState();
}

class _TimeTableTabState extends State<TimeTableTab> {
  DateTime? _pickedDate;

  @override
  Widget build(BuildContext context) {
    var store = context.read<TimetableStore>();
    return LoginStore.isGuest
        ? const GuestRestrictAccess()
        : Observer(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Tertiary Button Group: Timetable / Exam Schedule toggle ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OSpacing.m,
                    vertical: OSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!store.isTimetable) store.setTT();
                          },
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: store.isTimetable ? OColor.gray200 : Colors.transparent,
                              borderRadius: BorderRadius.circular(OSpacing.m),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Timetable',
                              style: OTextStyle.labelSmall.copyWith(
                                color: store.isTimetable ? OColor.green600 : OColor.gray600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: OSpacing.xs),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (store.isTimetable) store.setTT();
                          },
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: !store.isTimetable ? OColor.gray200 : Colors.transparent,
                              borderRadius: BorderRadius.circular(OSpacing.m),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Exam Schedule',
                              style: OTextStyle.labelSmall.copyWith(
                                color: !store.isTimetable ? OColor.green600 : OColor.gray600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Content ──
                Expanded(
                  child:
                      store.isTimetable
                          ? _buildTimetableView(store)
                          : _buildExamScheduleView(store),
                ),
              ],
            );
          },
        );
  }

  // ─── Timetable view: date selector + timeline ──────────────────────
  Widget _buildTimetableView(TimetableStore store) {
    return Column(
      children: [
        // Date selector
        SizedBox(
          height: 72,
          child: DateSlider(
            pickedDate: _pickedDate,
            onDateButtonTap: () => _showDatePickerSheet(store),
            onClearPickedDate: () {
              setState(() {
                _pickedDate = null;
                store.setDay(store.dates[store.selectedDate].weekday - 1);
              });
            },
          ),
        ),
        Divider(height: 1, thickness: 1, color: OColor.gray200),
        // Timeline
        Expanded(
          child: FutureBuilder(
            future: store.initialiseTT(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return ListShimmer();
              return Observer(builder: (context) => _buildTimeline(store));
            },
          ),
        ),
      ],
    );
  }

  // ─── Timeline: 7 AM → 7 PM with hour markers ─────────────────────
  Widget _buildTimeline(TimetableStore store) {
    final dayIndex = store.selectedDay;

    if (dayIndex < 0 || dayIndex > 4) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'No classes on this day',
            style: OTextStyle.labelSmall.copyWith(color: OColor.gray500),
          ),
        ),
      );
    }

    final dayName = kworkingDays[dayIndex]!;
    final allCourses = [
      ...store.allTimetableCourses[dayIndex].morning,
      ...store.allTimetableCourses[dayIndex].afternoon,
    ];

    if (allCourses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'No classes on this day',
            style: OTextStyle.labelSmall.copyWith(color: OColor.gray500),
          ),
        ),
      );
    }

    // Group courses by start hour (24 h)
    final Map<int, List<CourseModel>> coursesByHour = {};
    for (final course in allCourses) {
      final hour = _getStartHour24(course.timings?[dayName]?.toString());
      if (hour != null) {
        coursesByHour.putIfAbsent(hour, () => []).add(course);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: OSpacing.m, bottom: OSpacing.xl),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int hour = 7; hour <= 19; hour++) ...[
              _TimeMarkerRow(hour: hour),
              if (coursesByHour.containsKey(hour))
                ...coursesByHour[hour]!.map(
                  (course) => Padding(
                    padding: const EdgeInsets.only(
                      left: 78,
                      top: OSpacing.xxs,
                      bottom: OSpacing.xxs,
                    ),
                    child: TimetableTile(course: course),
                  ),
                )
              else
                const SizedBox(height: 60),
            ],
          ],
        ),
      ),
    );
  }

  /// Parse start hour from timing string to 24 h int.
  /// "09:00 - 09:55 AM" → 9, "02:00 - 02:55 PM" → 14
  int? _getStartHour24(String? timing) {
    if (timing == null || timing.isEmpty) return null;
    final parts = timing.split(' - ');
    if (parts.isEmpty) return null;
    final startHour = int.tryParse(parts[0].split(':')[0]);
    if (startHour == null) return null;
    // Timetable hours: 1–6 are PM (13–18), 7–12 stay as-is.
    if (startHour >= 1 && startHour <= 6) return startHour + 12;
    return startHour;
  }

  // ─── Date-picker bottom sheet ─────────────────────────────────────
  void _showDatePickerSheet(TimetableStore store) {
    DateTime tempDate = _pickedDate ?? DateTime.now();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: OColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(OCornerRadius.l)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(OSpacing.m, OSpacing.l, OSpacing.m, OSpacing.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: OColor.gray800),
                      const SizedBox(width: OSpacing.xs),
                      Text(
                        'Search by Date',
                        style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(sheetCtx),
                        child: Icon(Icons.close, size: 24, color: OColor.gray600),
                      ),
                    ],
                  ),
                  const SizedBox(height: OSpacing.m),
                  // Calendar
                  OCalendar(
                    dateSelected: (date) {
                      setSheetState(() => tempDate = date);
                    },
                  ),
                  const SizedBox(height: OSpacing.m),
                  // Select button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OColor.green600,
                        foregroundColor: OColor.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(OCornerRadius.m),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetCtx);
                        _onDatePicked(tempDate, store);
                      },
                      child: Text(
                        'Select',
                        style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onDatePicked(DateTime date, TimetableStore store) {
    setState(() {
      _pickedDate = date;
      store.setDay(date.weekday - 1);
    });
  }

  /// Exam schedule view: Midsem / Endsem toggle + exam list
  Widget _buildExamScheduleView(TimetableStore store) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
      child: FutureBuilder<RegisteredCourses>(
        future: store.getCourses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return ListShimmer();
          if (!snapshot.hasData) return ListShimmer();
          return ScheduleList(data: snapshot.requireData);
        },
      ),
    );
  }
}

// ─── Time marker row ─────────────────────────────────────────────────────

class _TimeMarkerRow extends StatelessWidget {
  final int hour; // 24 h format (7–19)
  const _TimeMarkerRow({required this.hour});

  String get _label {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '${hour}:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            _label,
            style: OTextStyle.labelXSmall.copyWith(
              color: OColor.gray600,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: OColor.gray200)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Exam Schedule list with Midsem / Endsem toggle
// ─────────────────────────────────────────────────────────────────────────────

class ScheduleList extends StatefulWidget {
  final RegisteredCourses data;
  const ScheduleList({super.key, required this.data});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  bool isMidsDone = false;
  bool showEndsem = false; // toggle state for Midsems / Endsems

  List<CourseModel> _sort(List<CourseModel> input, {String type = 'midsem'}) {
    if (type == 'midsem') {
      input.removeWhere((e) => e.midsem == null || e.midsem == '');
      input.sort((a, b) => DateTime.parse(a.midsem!).isAfter(DateTime.parse(b.midsem!)) ? 1 : -1);
      if (input.isNotEmpty && DateTime.parse(input.last.midsem!).isBefore(DateTime.now())) {
        isMidsDone = true;
      }
    } else {
      input.removeWhere((e) => e.endsem == null || e.endsem == '');
      input.sort((a, b) => DateTime.parse(a.endsem!).isAfter(DateTime.parse(b.endsem!)) ? 1 : -1);
    }
    return input;
  }

  Widget get _noData => Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Text('No data found', style: OTextStyle.labelSmall.copyWith(color: OColor.gray500)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.data.courses == null || widget.data.courses!.isEmpty) {
      return _noData;
    }

    List<CourseModel> endsem = _sort(List.from(widget.data.courses!), type: 'endsem');
    List<CourseModel> midsem = _sort(List.from(widget.data.courses!));
    for (var c in midsem) c.venue = c.midsemVenue;
    for (var c in endsem) c.venue = c.endsemVenue;

    // Auto-select endsems if mids are done
    if (isMidsDone && !showEndsem) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => showEndsem = true);
      });
    }

    final courses = showEndsem ? endsem : midsem;

    return Column(
      children: [
        // Midsems / Endsems toggle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
          child: Row(
            children: [
              _ExamToggleButton(
                label: 'Midsems',
                selected: !showEndsem,
                onTap: () => setState(() => showEndsem = false),
              ),
              const SizedBox(width: OSpacing.xs),
              _ExamToggleButton(
                label: 'Endsems',
                selected: showEndsem,
                onTap: () => setState(() => showEndsem = true),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: OSpacing.xs),
        // Exam list
        Expanded(
          child:
              courses.isEmpty
                  ? _noData
                  : ListView.separated(
                    itemCount: courses.length,
                    separatorBuilder: (_, _) => const SizedBox(height: OSpacing.xs),
                    itemBuilder:
                        (context, index) => ExamTile(course: courses[index], isEndSem: showEndsem),
                  ),
        ),
      ],
    );
  }
}

/// Pill-style toggle button for Midsems / Endsems
class _ExamToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ExamToggleButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? OColor.green600 : OColor.white,
            borderRadius: BorderRadius.circular(OCornerRadius.m),
            border: selected ? null : Border.all(color: OColor.gray300),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: OTextStyle.labelSmall.copyWith(color: selected ? OColor.white : OColor.gray600),
          ),
        ),
      ),
    );
  }
}
