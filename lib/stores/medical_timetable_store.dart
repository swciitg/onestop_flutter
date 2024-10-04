// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:onestop_dev/models/medicaltimetable/all_doctors.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_dev/models/medicaltimetable/medical_timetable_day.dart';
import 'package:onestop_dev/services/data_provider.dart';

part 'medical_timetable_store.g.dart';

class MedicalTimetableStore = _MedicalTimetableStore
    with _$MedicalTimetableStore;

abstract class _MedicalTimetableStore with Store {
  List<MedicalTimetableDay> allmedicalTimetable =
      List.generate(7, (index) => MedicalTimetableDay());

  @observable
  bool isProcessed = false;

  @observable
  AllDoctors? doctors;

  initialiseMedicalTT() async {
    if (!isProcessed) {
      initialiseMedicalDates();
      await processMedicalTimetable();
      isProcessed = true;
    }
    return "Success";
  }

  List<DateTime> dates = List.filled(7, DateTime.now());

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
  bool get institutionDoctorsPresent =>
      allmedicalTimetable[selectedDate].institute_docs.isNotEmpty;

  @computed
  bool get visitingDoctorsPresent =>
      allmedicalTimetable[selectedDate].visiting_docs.isNotEmpty;

  @computed
  List<DoctorModel> get todayMedicalTimeTable {
    int timetableIndex = selectedDate;
    List<DoctorModel> list = [
      ...allmedicalTimetable[timetableIndex].institute_docs,
      ...allmedicalTimetable[timetableIndex].visiting_docs
    ];
    return list;
  }

  Future<void> processMedicalTimetable() async {
    List<MedicalTimetableDay> medicalTimetableDay =
        List.generate(7, (index) => MedicalTimetableDay());

    var doctorsList = await DataProvider.getMedicalTimeTable();
    updateDateList(dates); // datematch is the list of translated dates of the week
    for (int i = 0; i < 7; i++) {
      final date = datematch[i];
      for (var doctor in doctorsList.alldoctors!) {
        DoctorModel copyDoctor = DoctorModel.clone(doctor);
        final docdate = copyDoctor.date ?? "";
        final docCategory = copyDoctor.category;
        if (date == docdate) {
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
