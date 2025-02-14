import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';

class APIRepository extends OneStopApi {
  final dio2 = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  APIRepository()
      : super(
          onestopBaseUrl: Endpoints.baseUrl,
          serverBaseUrl: Endpoints.baseUrl,
          onestopSecurityKey: Endpoints.apiSecurityKey,
          onRefreshTokenExpired: () async {
            await LoginStore().clearAppData();
            showSnackBar("Your session has expired!! Login again.");
          },
        );

  Future<bool> postFeedbackData(Map<String, String> data) async {
    String tag = data['type'] == 'Issue Report' ? 'bug' : 'enhancement';
    String newBody =
        "### Description :\n${data['body']}\n### Posted By :\n${data['user']}";

    var res = await dio2.post(Endpoints.feedback,
        data: {
          'title': data['title'],
          'body': newBody,
          'labels': [tag]
        },
        options: Options(headers: {
          'Accept': 'application/vnd.github+json',
          'Authorization': 'Bearer ${Endpoints.githubIssueToken}'
        }));
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> getLastUpdated() async {
    var response = await serverDio.get(Endpoints.lastUpdatedURL);
    var status = response.statusCode;
    var body = response.data;
    if (status == 200) {
      Map<String, dynamic> data = body;
      return data;
    } else {
      throw Exception("Data could not be fetched");
    }
  }

  Future<List<Map<String, dynamic>>> getContactData() async {
    var response = await serverDio.get(Endpoints.contactURL);
    var status = response.statusCode;
    var body = response.data;
    if (status == 200) {
      List<Map<String, dynamic>> data = [];
      for (var json in body) {
        data.add(json);
      }
      return data;
    } else {
      throw Exception("contact Data could not be fetched");
    }
  }

  Future<List<Map<String, dynamic>>> getDropDownContacts() async {
    var response = await serverDio.get(Endpoints.dropownDoctors);
    var status = response.statusCode;
    var body = response.data;
    if (status == 200) {
      List<Map<String, dynamic>> data = [];
      for (var json in body) {
        data.add(json as Map<String, dynamic>);
      }
      return data;
    } else {
      throw Exception("Medical Contact Data could not be fetched");
    }
  }

  Future<Map<String, dynamic>> getHomePageUrls() async {
    var response = await serverDio.get(Endpoints.homePageUrls);
    var status = response.statusCode;
    var json = response.data;
    if (status == 200) {
      return json;
    } else {
      throw Exception("Quick links could not be fetched");
    }
  }

  Future<RegisteredCourses> getTimeTable({required String roll}) async {
    final response = await dio2.post(
      Endpoints.timetableURL,
      data: {
        "roll_number": roll,
      },
    );
    if (response.statusCode == 200) {
      return RegisteredCourses.fromJson(response.data);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<LatLng>> getPolyline(
      {required LatLng source, required LatLng dest}) async {
    final response = await serverDio.get(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248b144cc92443247b7b9e0bd5df85012f2&start=8.681495,49.41461&end=8.687872,49.420318',
    );
    if (response.statusCode == 200) {
      var body = response.data;
      List<LatLng> res = [];
      for (var r in body['features'][0]['geometry']['coordinates']) {
        res.add(LatLng(r[0], r[1]));
      }
      return res;
    } else {
      throw Exception(response.data);
    }
  }

  Future<Map<String, dynamic>> postUPSP(Map<String, dynamic> data) async {
    var res = await serverDio.post(Endpoints.upspPost, data: data);
    return res.data;
  }

  Future<String?> uploadFileToServer(File file, String endpoint) async {
    var fileName = file.path.split('/').last;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    try {
      var response = await serverDio.post(
        endpoint,
        options: Options(contentType: 'multipart/form-data'),
        data: formData,
        onSendProgress: (int send, int total) {
          // TODO: Show send/total percent as progress indicator
        },
      );
      if (response.statusCode == 200) {
        return response.data['filename'];
      }
      return null;
    } catch (e) {
      print("Upload" + e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> postHAB(Map<String, dynamic> data) async {
    var res = await serverDio.post(Endpoints.habPost, data: data);
    return res.data;
  }

  Future<String?> uploadFileToServer2(File file) async {
    var fileName = file.path.split('/').last;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    try {
      var response = await serverDio.post(
        Endpoints.uploadFileHAB,
        options: Options(contentType: 'multipart/form-data'),
        data: formData,
        onSendProgress: (int send, int total) {
          // TODO: Show send/total percent as progress indicator
        },
      );
      if (response.statusCode == 200) {
        return response.data['filename'];
      }
      return null;
    } on DioException {
      return null;
    }
  }
}
