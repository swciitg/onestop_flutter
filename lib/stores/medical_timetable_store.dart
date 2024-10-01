// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/class_timings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicaltimetable/all_doctors.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_dev/models/medicaltimetable/medical_timetable_day.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_timetable_tile.dart';
import 'package:onestop_dev/widgets/ui/text_divider.dart';
import 'package:onestop_kit/onestop_kit.dart';

part 'medical_timetable_store.g.dart';

class MedicalTimetableStore = _MedicalTimetableStore
    with _$MedicalTimetableStore;

abstract class _MedicalTimetableStore with Store {
  //List of medical time table of each day of the week
  List<MedicalTimetableDay> allmedicalTimetable =
      List.generate(7, (index) => MedicalTimetableDay());

  @observable
  bool isProcessed = false;

  @observable
  AllDoctors? doctors;

  Future<AllDoctors> getDoctors() async {
    doctors ??= await DataProvider.getMedicalTimeTable();
    return doctors!;
  }

  initialiseMedicalTT() async {
    if (!isProcessed) {
      initialiseMedicalDates();
      await processMedicalTimetable();
      isProcessed = true;
    }
    return "Success";
  }

  //List of dates to show in the date slider
  List<DateTime> dates = List.filled(7, DateTime.now());

  //Initialising the dates
  void initialiseMedicalDates() {
    dates = List.filled(7, DateTime.now());
    for (int i = 1; i < 7; i++) {
      dates[i] = dates[i - 1].add(const Duration(days: 1));
    }
  }

  List<String> datematch = List.filled(7, "");

  void updateDateList(List<DateTime> dateTimes) {
    for (int i = 0; i < dateTimes.length; i++) {
      String day = dateTimes[i].day.toString().padLeft(2, '0');
      String month = dateTimes[i].month.toString().padLeft(2, '0');
      String year = dateTimes[i].year.toString();
      datematch[i] = '$year-$month-$day';
      print(datematch[i] + i.toString());
    }
  }

  //index of date slider item
  @observable
  int selectedDate = 0;

  @action
  void setDate(int i) {
    selectedDate = i;
  }

  //index of selected day
  @observable
  int selectedDay = DateTime.now().weekday - 1;

  @action
  void setDay(int i) {
    selectedDay = i;
  }

  @computed
  List<Widget> get todayMedicalTimeTable {
    int timetableIndex = selectedDate;
    bool instituteDocsPresent =
        allmedicalTimetable[timetableIndex].institute_docs.isEmpty;
    bool visitingDocsPresent =
        allmedicalTimetable[timetableIndex].visiting_docs.isEmpty;
    List<Widget> l = [
      !instituteDocsPresent
          ? const TextDivider(
              text: 'Institute Doctors',
            )
          : const SizedBox(
              height: 0,
            ),
      ...allmedicalTimetable[timetableIndex]
          .institute_docs
          .map((e) => MedicalTimetableTile(doctor: e))
          .toList(),
      !visitingDocsPresent
          ? const TextDivider(
              text: 'Visiting Doctors',
            )
          : const SizedBox(
              height: 0,
            ),
      ...allmedicalTimetable[timetableIndex]
          .visiting_docs
          .map((e) => MedicalTimetableTile(doctor: e))
          .toList()
    ];
    if (l.length == 2) {
      l = [
        Center(
          child: Text(
            'No data found',
            style: MyFonts.w500.size(14).setColor(kGrey8),
          ),
        )
      ];
    }
    return l;
  }

  Future<void> processMedicalTimetable() async {
    //A list of timetable of each day, with index 0 to 4 signifying mon to fri
    List<MedicalTimetableDay> medicalTimetableDay =
        List.generate(7, (index) => MedicalTimetableDay());

    //Lets fill the above now
    var doctorsList = await getDoctors();
    updateDateList(
        dates); // datematch is the list of translated dates of the week
    for (int i = 0; i < 7; i++) {
      final date = datematch[i];
      for (var doctor in doctorsList.alldoctors!) {
        DoctorModel copyDoctor = DoctorModel.clone(doctor);
        final docdate = copyDoctor.date ?? "";
        final docCategory = copyDoctor.category;
        if (date == docdate) {
          print(date);
          print(docdate);
          print(i.toString());
          if (docCategory == "Institute_Docs") {
            medicalTimetableDay[i].institute_docs.add(copyDoctor);
          } else {
            medicalTimetableDay[i].visiting_docs.add(copyDoctor);
          }
        }
      }
      medicalTimetableDay[i].institute_docs.sort((a, b) {
        int t1 = int.parse(b.startTime1.toString().split(':')[0]);
        int t2 = int.parse(b.startTime1.toString().split(':')[0]);
        return t1.compareTo(t2);
      });
      medicalTimetableDay[i].visiting_docs.sort((a, b) {
        int t1 = int.parse(a.startTime1.toString().split(':')[0]);
        int t2 = int.parse(b.startTime1.toString().split(':')[0]);
        return t1.compareTo(t2);
      });
    }
    allmedicalTimetable = medicalTimetableDay;
  }
}
