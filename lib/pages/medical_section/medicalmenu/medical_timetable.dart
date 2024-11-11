import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_dev/stores/medical_timetable_store.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_date_slider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalTimetable extends StatefulWidget {
  const MedicalTimetable({Key? key}) : super(key: key);

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
      appBar: _buildAppBar(context),
      backgroundColor: OneStopColors.backgroundColor,
      body: SafeArea(
        child: Observer(
          builder: (context) {
            return Column(
              children: [
                const SizedBox(
                  height: 130,
                  child: MedicalDateSlider(),
                ),
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

                      return Observer(builder: (context) {
                        final docs = store.todayMedicalTimeTable;

                        // Determine if the selected day is today
                        final isToday = store.selectedDate == 0;
                        DateTime displayDate;

                        // Set displayDate to current time if today, or midnight if another day
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
                          todayHighlightColor: kWhite,
                          showCurrentTimeIndicator: true,
                          view: CalendarView.timelineDay,
                          maxDate: maxDate,
                          minDate: minDate,
                          dataSource: EventDataSource(docs, selectedDate: displayDate),
                          timeSlotViewSettings: TimeSlotViewSettings(
                            timeInterval: const Duration(hours: 1),
                            timeIntervalWidth: 80,
                            timeTextStyle: MyFonts.w500.setColor(kWhite),
                          ),
                          headerStyle: CalendarHeaderStyle(
                            textStyle: MyFonts.w500.setColor(kWhite),
                            backgroundColor: kBackground,
                          ),
                          cellBorderColor: kGrey2,
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
                                      backgroundColor: kBlueGrey,
                                      title: Text('Doctor Information',
                                          style: MyFonts.w500.setColor(kWhite)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Name: ${doctor.doctor.name!}',
                                              style: MyFonts.w500.setColor(kWhite)
                                                  .copyWith(fontSize: 14)),
                                          const SizedBox(height: 5),
                                          Text('Degree: ${doctor.doctor.degree!}',
                                              style: MyFonts.w500.setColor(kWhite)
                                                  .copyWith(fontSize: 14)),
                                          const SizedBox(height: 5),
                                          Text('Category: ${doctor.doctor.designation!}',
                                              style: MyFonts.w500.setColor(kWhite)
                                                  .copyWith(fontSize: 14)),
                                          const SizedBox(height: 5),
                                          Text('Timings: ${doctor.startTime1!} - ${doctor.endTime1!}',
                                              style: MyFonts.w500.setColor(kWhite)
                                                  .copyWith(fontSize: 14)),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Close',
                                              style: MyFonts.w300.setColor(kWhite)),
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
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        doctor.doctor.name!,
                                        style: MyFonts.w600.setColor(kWhite)
                                            .copyWith(fontSize: 14),
                                        overflow: TextOverflow.clip,
                                      ),
                                      Text(
                                        doctor.doctor.degree!,
                                        style: MyFonts.w600.setColor(kWhite)
                                            .copyWith(fontSize: 14),
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
                            backgroundColor: kBackground,
                            dateTextStyle: MyFonts.w600
                                .setColor(kWhite)
                                .copyWith(color: Colors.transparent),
                            dayTextStyle: MyFonts.w600
                                .setColor(kWhite)
                                .copyWith(color: Colors.transparent),
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
                      });
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

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kAppBarGrey,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      "Medical TimeTable",
      textAlign: TextAlign.center,
      style: OnestopFonts.w500.size(20).setColor(kWhite),
    ),
    actions: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.clear,
          color: kWhite,
        ),
      ),
    ],
  );
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw "Cannot launch URL";
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
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hr,
      min,
    );
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
    return doc.category! == "Institute_docs" ? kTimetableDisabled : kTimetableGreen;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
