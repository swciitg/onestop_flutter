import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';

class MedicalTimetableDay {
  List<DoctorModel> institute_docs = [];
  List<DoctorModel> visiting_docs = [];

  void addInstitueDocs(DoctorModel c) => institute_docs.add(c);

  void addVisitingDocs(DoctorModel c) => visiting_docs.add(c);

  // @override
  // String toString() {
  //   return "Morning: ${morning.map((e) => e.toString())} | Noon: ${afternoon.map((e) => e.toString())}";
  // }
}
