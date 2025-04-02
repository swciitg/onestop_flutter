import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';

class MedicalTimetableDay {
  List<DoctorModel> instituteDocs = [];
  List<DoctorModel> visitingDocs = [];

  void addInstitueDocs(DoctorModel c) => instituteDocs.add(c);

  void addVisitingDocs(DoctorModel c) => visitingDocs.add(c);

  // @override
  // String toString() {
  //   return "Morning: ${morning.map((e) => e.toString())} | Noon: ${afternoon.map((e) => e.toString())}";
  // }
}
