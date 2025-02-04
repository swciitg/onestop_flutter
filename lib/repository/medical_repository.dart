import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/medicalcontacts/allmedicalcontacts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/models/medicaltimetable/all_doctors.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MedicalRepository extends OneStopApi {
  MedicalRepository()
      : super(
          onestopSecurityKey: Endpoints.apiSecurityKey,
          serverBaseUrl: Endpoints.baseUrl,
          onestopBaseUrl: Endpoints.baseUrl,
        );

  Future<Allmedicalcontacts?> getMedicalContactData() async {
    final response = await serverDio.get(
      Endpoints.medicalContactURL,
    );
    var body = response.data;
    Allmedicalcontacts allDocs = Allmedicalcontacts(alldoctors: []);
    if (response.statusCode == 200) {
      for (var json in body) {
        allDocs.addDocToList(MedicalcontactModel.fromJson(json));
      }
      return allDocs;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<AllDoctors> getmedicalTimeTable() async {
    final response = await serverDio.get(Endpoints.medicalTimetableURL);
    var body = response.data;

    final allDocs = AllDoctors(alldoctors: []);
    if (response.statusCode == 200) {
      for (var json in body) {
        final firstSession = DoctorModel.fromJson(json);
        DoctorModel? secondSession;
        if (firstSession.startTime2!.isNotEmpty) {
          secondSession = DoctorModel.clone(firstSession);
          secondSession.startTime1 = firstSession.startTime2;
          secondSession.endTime1 = firstSession.endTime2;
          firstSession.startTime2 = "";
          firstSession.endTime2 = "";
          secondSession.startTime2 = "";
          secondSession.endTime2 = "";
        }
        allDocs.addDocToList(firstSession);
        if (secondSession != null) {
          allDocs.addDocToList(secondSession);
        }
      }
      return allDocs;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Map<String, dynamic>> postPharmacyFeedback(
      Map<String, dynamic> data) async {
    var res = await serverDio.post(Endpoints.pharmacyFeedback, data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> postFacilityFeedback(
      Map<String, dynamic> data) async {
    var res =
        await serverDio.post(Endpoints.hospitalFacilitiesFeedback, data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> postDoctorFeedback(
      Map<String, dynamic> data) async {
    var res = await serverDio.post(Endpoints.doctorsFeedback, data: data);
    return res.data;
  }
}
