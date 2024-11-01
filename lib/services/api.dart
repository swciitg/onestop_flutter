import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/models/medicalcontacts/allmedicalcontacts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/models/medicaltimetable/all_doctors.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_kit/onestop_kit.dart';

class APIService extends OneStopApi {
  final dio2 = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  APIService()
      : super(
          onestopBaseUrl: Endpoints.baseUrl,
          serverBaseUrl: Endpoints.baseUrl,
          onestopSecurityKey: Endpoints.apiSecurityKey,
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

  Future<Response> guestUserLogin() async {
    var response = await serverDio.post(Endpoints.guestLogin);
    return response;
  }

  Future<Map> getUserProfile() async {
    try {
      var response = await serverDio.get(Endpoints.userProfile);
      return response.data;
    } catch (e) {
      throw DioException(
          requestOptions: RequestOptions(path: Endpoints.userProfile),
          response: (e as DioException).response);
    }
  }

  Future<void> updateUserProfile(Map data, String? deviceToken) async {
    Map<String, dynamic> queryParameters = {};
    if (deviceToken != null) queryParameters["deviceToken"] = deviceToken;
    await serverDio.patch(Endpoints.userProfile,
        data: data, queryParameters: queryParameters);
  }

  Future<List<Response>> getNotifications() async {
    final results = await Future.wait([
      serverDio.get(Endpoints.generalNotifications),
      serverDio.get(Endpoints.userNotifications)
    ]);
    return results;
  }

  Future<void> deletePersonalNotif() async {
    await serverDio.delete(Endpoints.userNotifications);
  }

  Future<void> postUserDeviceToken(String deviceToken) async {
    await serverDio
        .post(Endpoints.userDeviceTokens, data: {"deviceToken": deviceToken});
  }

  Future<void> updateUserDeviceToken(Map data) async {
    await serverDio.patch(Endpoints.userDeviceTokens, data: data);
  }

  Future<void> updateUserNotifPref(Map data) async {
    await serverDio.patch(Endpoints.userNotifPrefs, data: data);
  }

  Future<List<Map<String, dynamic>>> getRestaurantData() async {
    var response = await serverDio.get(Endpoints.restaurantURL);
    var status = response.statusCode;
    var body = response.data;
    if (status == 200) {
      List<Map<String, dynamic>> data = [];
      for (var json in body) {
        data.add(json);
      }
      return data;
    } else {
      throw Exception("Data could not be fetched");
    }
  }

  Future<dynamic> claimFoundItem(
      {required String name, required String email, required String id}) async {
    var res = await serverDio.post(Endpoints.claimItemURL,
        data: {"id": id, "claimerEmail": email, "claimerName": name});
    return res.data;
  }

  Future<void> deleteBnsMyAd(String id, String email) async {
    await serverDio
        .post(Endpoints.deleteBuyURL, data: {'id': id, 'email': email});
    await serverDio
        .post(Endpoints.deleteSellURL, data: {'id': id, 'email': email});
  }

  Future<void> deleteLnfMyAd(String id, String email) async {
    await serverDio
        .post(Endpoints.deleteLostURL, data: {'id': id, 'email': email});
    await serverDio
        .post(Endpoints.deleteFoundURL, data: {'id': id, 'email': email});
  }

  Future<List> getBuyItems() async {
    var response = await serverDio.get(Endpoints.buyURL);
    return response.data.details;
  }

  Future<List> getSellItems() async {
    var res = await serverDio.get(Endpoints.sellURL);
    return res.data.details;
  }

  Future<List<BuyModel>> getBnsMyItems(String mail, bool isSell) async {
    var res =
        await serverDio.post(Endpoints.bnsMyAdsURL, data: {'email': mail});
    var myItemsDetails = res.data;
    var sellList = (myItemsDetails["details"]["sellList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    var buyList = (myItemsDetails["details"]["buyList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    if (isSell) {
      return sellList;
    } else {
      return buyList;
    }
  }

  Future<List<dynamic>> getLnfMyItems(String mail, bool isLost) async {
    var res =
        await serverDio.post(Endpoints.lnfMyAdsURL, data: {'email': mail});
    var myItemsDetails = res.data;
    var foundList = (myItemsDetails["details"]["foundList"] as List)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    var lostList = (myItemsDetails["details"]["lostList"] as List)
        .map((e) => LostModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    if (isLost) {
      return lostList;
    } else {
      return foundList;
    }
  }

  Future<List> getLostItems() async {
    var res = await serverDio.get(Endpoints.lostURL);
    var lostItemsDetails = res.data;
    return lostItemsDetails["details"];
  }

  Future<List<LostModel>> getLostPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    var response = await serverDio.get(Endpoints.lostPath,
        queryParameters: queryParameters);
    var json = response.data;
    List<LostModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => LostModel.fromJson(e))
        .toList();
    // await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  Future<List<FoundModel>> getFoundPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    var response = await serverDio.get(Endpoints.foundPath,
        queryParameters: queryParameters);
    var json = response.data;
    List<FoundModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  Future<List<BuyModel>> getSellPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    var response = await serverDio.get(Endpoints.sellPath,
        queryParameters: queryParameters);
    var json = response.data;
    List<BuyModel> sellPage = (json['details'] as List<dynamic>)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    return sellPage;
  }

  Future<List<SellModel>> getBuyPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    var response = await serverDio.get(Endpoints.buyPath,
        queryParameters: queryParameters);
    var json = response.data;
    List<SellModel> buyPage = (json['details'] as List<dynamic>)
        .map((e) => SellModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    return buyPage;
  }

  Future<List> getFoundItems() async {
    var res = await serverDio.get(Endpoints.foundURL);
    var foundItemsDetails = res.data;
    return foundItemsDetails["details"];
  }

  Future<Map<String, dynamic>> postSellData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.sellURL, data: {
      'title': data['title'],
      'description': data['description'],
      'price': data['price'],
      'imageString': data['image'],
      'phonenumber': data['contact'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
  }

  Future<Map<String, dynamic>> postBuyData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.buyURL, data: {
      'title': data['title'],
      'description': data['description'],
      'price': data['total_price'],
      'imageString': data['image'],
      'phonenumber': data['contact'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
  }

  Future<Map<String, dynamic>> postLostData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.lostURL, data: {
      'title': data['title'],
      'description': data['description'],
      'location': data['location'],
      'imageString': data['image'],
      'phonenumber': data['contact'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
  }

  Future<Map<String, dynamic>> postFoundData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.foundURL, data: {
      'title': data['title'],
      'description': data['description'],
      'location': data['location'],
      'imageString': data['image'],
      'submittedat': data['submittedAt'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
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

  Future<Allmedicalcontacts?> getMedicalContactData() async {
    final response = await serverDio.get(
      Endpoints.medicalContactURL, // chusuko
    );
    var body = response.data;
    Allmedicalcontacts alldoc = Allmedicalcontacts(alldoctors: []);
    if (response.statusCode == 200) {
      for (var json in body) {
        alldoc.addDocToList(MedicalcontactModel.fromJson(json));
      }
      return alldoc;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<AllDoctors> getmedicalTimeTable() async {
    final response = await serverDio.get(Endpoints.medicalTimetableURL);
    var body = response.data;

    AllDoctors alldoc = AllDoctors(alldoctors: []);
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
        alldoc.addDocToList(firstSession);
        if (secondSession != null) {
          alldoc.addDocToList(secondSession);
        }
      }
      return alldoc;
    } else {
      throw Exception(response.statusCode);
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

  Future<List<Map<String, dynamic>>> getFerryData() async {
    var response = await serverDio.get(Endpoints.ferryURL);
    var status = response.statusCode;
    var json = response.data;
    if (status == 200) {
      List<Map<String, dynamic>> answer = [];
      for (var temp in json) {
        answer.add(temp);
      }
      return answer;
    } else {
      throw Exception("Ferry Data could not be fetched");
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

  Future<List<Map<String, dynamic>>> getMessMenu() async {
    var response = await serverDio.get(Endpoints.messURL);
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

  Future<Map<String, dynamic>> getFerryTiming() async {
    try {
      Response res = await serverDio.get(Endpoints.ferryURL);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMealData() async {
    try {
      final res = await serverDio.get(Endpoints.messURL);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBusTiming() async {
    try {
      final res = await serverDio.get(Endpoints.busStops);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
