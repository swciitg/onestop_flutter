import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_dev/stores/medical_timetable_store.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_date_slider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MedicalTimetable extends StatefulWidget {
  const MedicalTimetable({super.key});

  @override
  State<MedicalTimetable> createState() => _MedicalTimetableState();
}

class _MedicalTimetableState extends State<MedicalTimetable> {
  late final CalendarController calendarController;

  @override
  void initState() {
    calendarController = CalendarController();
    calendarController.selectedDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var store = context.read<MedicalTimetableStore>();
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Medical TimeTable',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: SafeArea(
        child: Observer(
          builder: (context) {
            return Column(
              children: [
                const SizedBox(height: 130, child: MedicalDateSlider()),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder(
                    future: store.initialiseMedicalTT(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ListShimmer();
                      }
                      final minDate = DateTime.now();
                      final maxDate = minDate.add(const Duration(days: 6));

                      return Observer(
                        builder: (context) {
                          final docs = store.todayMedicalTimeTable;

                          final isToday = store.selectedDate == 0;
                          DateTime displayDate;

                          if (isToday) {
                            displayDate = DateTime.now();
                          } else {
                            displayDate = DateTime.now()
                                .add(Duration(days: store.selectedDate))
                                .copyWith(hour: 7, minute: 0);
                          }

                          calendarController.displayDate = displayDate;

                          return SfCalendar(
                            controller: calendarController,
                            todayHighlightColor: OColor.green600,
                            showCurrentTimeIndicator: true,
                            view: CalendarView.timelineDay,
                            maxDate: maxDate,
                            minDate: minDate,
                            dataSource: EventDataSource(docs, selectedDate: displayDate),
                            timeSlotViewSettings: TimeSlotViewSettings(
                              timeInterval: const Duration(hours: 1),
                              timeIntervalWidth: 80,
                              timeTextStyle: OTextStyle.bodyXSmall.copyWith(color: OColor.gray700),
                            ),
                            headerStyle: CalendarHeaderStyle(
                              textStyle: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                              backgroundColor: OColor.white,
                            ),
                            cellBorderColor: OColor.gray200,
                            selectionDecoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onDragUpdate: (details) {
                              if (details.draggingTime == null) return;
                              setState(() {
                                int date = details.draggingTime!.day - DateTime.now().day;
                                if (date >= 0 && date < 7) {
                                  store.selectedDate = date;
                                }
                              });
                            },
                            appointmentBuilder: (context, calendarAppointmentDetails) {
                              final docs = (calendarAppointmentDetails.appointments).toList();
                              final doctor = docs.first as DoctorModel;
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: OColor.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(OCornerRadius.l),
                                        ),
                                        title: Text(
                                          'Doctor Information',
                                          style: OTextStyle.headingSmall.copyWith(
                                            color: OColor.gray800,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name: ${doctor.doctor.name!}',
                                              style: OTextStyle.bodySmall.copyWith(
                                                color: OColor.gray700,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Degree: ${doctor.doctor.degree!}',
                                              style: OTextStyle.bodySmall.copyWith(
                                                color: OColor.gray700,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Category: ${doctor.doctor.designation!}',
                                              style: OTextStyle.bodySmall.copyWith(
                                                color: OColor.gray700,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Timings: ${doctor.startTime1!} - ${doctor.endTime1!}',
                                              style: OTextStyle.bodySmall.copyWith(
                                                color: OColor.gray700,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Close',
                                              style: OTextStyle.bodySmall.copyWith(
                                                color: OColor.gray600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: OColor.green100,
                                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                                    border: Border.all(color: OColor.green600),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          doctor.doctor.name!,
                                          style: OTextStyle.labelSmall.copyWith(
                                            color: OColor.green600,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                        Text(
                                          doctor.doctor.degree!,
                                          style: OTextStyle.bodyXSmall.copyWith(
                                            color: OColor.gray700,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            viewHeaderHeight: 0,
                            viewHeaderStyle: ViewHeaderStyle(
                              backgroundColor: OColor.white,
                              dateTextStyle: OTextStyle.bodySmall.copyWith(
                                color: Colors.transparent,
                              ),
                              dayTextStyle: OTextStyle.bodySmall.copyWith(
                                color: Colors.transparent,
                              ),
                            ),
                            allowAppointmentResize: true,
                            allowDragAndDrop: false,
                            onViewChanged: (viewChangedDetails) {
                              final days = viewChangedDetails.visibleDates;
                              final index = days.first.day - DateTime.now().day;
                              store.setDate(index);
                              store.setDay(store.dates[index].weekday - 1);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  final DateTime selectedDate;
  EventDataSource(List<DoctorModel> source, {required this.selectedDate}) {
    appointments = source;
  }

  DateTime getDateTime(String dateString) {
    final data = dateString.split(" ");
    final splits = data.first.split(":");
    var hr = int.parse(splits.first);
    final min = int.parse(splits.last);
    if (data.last == "PM" && hr != 12) {
      hr += 12;
    }
    return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hr, min);
  }

  @override
  DateTime getStartTime(int index) {
    return getDateTime((appointments![index] as DoctorModel).startTime1!);
  }

  @override
  DateTime getEndTime(int index) {
    return getDateTime((appointments![index] as DoctorModel).endTime1!);
  }

  @override
  String getSubject(int index) {
    final doctor = (appointments![index] as DoctorModel);
    return "${doctor.doctor.name!}  ${doctor.doctor.degree!}";
  }

  @override
  Color getColor(int index) {
    final doc = (appointments![index] as DoctorModel);
    return doc.category! == "Institute_docs" ? OColor.gray200 : OColor.green600;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
