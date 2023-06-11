import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/utility/show_snackbar.dart';
import '../models/food/mess_menu_model.dart';
import '../models/travel/travel_timing_model.dart';
import '../functions/utility/auth_user_helper.dart';

class APIService {

  final dio = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  APIService() {

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
          print("THIS IS TOKEN");
          print(await AuthUserHelpers.getAccessToken());
      options.headers["Authorization"] =
      "Bearer ${await AuthUserHelpers.getAccessToken()}";
      handler.next(options);
    }, onError: (error, handler) async {
      var response = error.response;
      if (response != null && response.statusCode == 401) {
        print(response.requestOptions.path);
        bool couldRegenerate = await regenerateAccessToken();
        // ignore: use_build_context_synchronously
        if (couldRegenerate) {
          // retry
          return handler.resolve(await retryRequest(response));
        } else {
          showSnackBar("Your session has expired!! Login again.");
        }
      }
      else if(response != null && response.statusCode == 403){
        showSnackBar("Access not allowed in guest mode");
      }
      // admin user with expired tokens
      return handler.next(error);
    }));
  }

  Future<Response<dynamic>> retryRequest(Response response) async {
    RequestOptions requestOptions = response.requestOptions;
    response.requestOptions.headers[BackendHelper.authorization] =
    "Bearer ${await AuthUserHelpers.getAccessToken()}";
    final options = Options(method: requestOptions.method, headers: requestOptions.headers);
    Dio retryDio = Dio(BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Security-Key': Endpoints.apiSecurityKey
        }));
    if (requestOptions.method == "GET") {
      return retryDio.request(requestOptions.path,
          queryParameters: requestOptions.queryParameters, options: options);
    } else {
      return retryDio.request(requestOptions.path,
          queryParameters: requestOptions.queryParameters,
          data: requestOptions.data,
          options: options);
    }
  }

  Future<bool> regenerateAccessToken() async {
    String refreshToken = await AuthUserHelpers.getRefreshToken();
    try {
      Dio regenDio = Dio(BaseOptions(
          baseUrl: Endpoints.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {
            'Security-Key': Endpoints.apiSecurityKey
          }));
      Response<Map<String, dynamic>> resp = await regenDio.post(
          "/user/accesstoken",
          options: Options(headers: {"authorization": "Bearer $refreshToken"}));
      var data = resp.data!;
      await AuthUserHelpers.setAccessToken(data["token"]);
      return true;
    } catch (err) {
      return false;
    }
  }


  Future<bool> postFeedbackData(Map<String, String> data) async {
    String tag = data['type'] == 'Issue Report' ? 'bug' : 'enhancement';
    String newBody =
        "### Description :\n${data['body']}\n### Posted By :\n${data['user']}";

    var res = await dio.post(Endpoints.feedback,
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
    var response = await dio.post(Endpoints.guestLogin);
    return response;
  }

  Future<Map> getUserProfile() async {
    var response = await dio.get(Endpoints.userProfile);
    return response.data;
  }

  Future<void> updateUserProfile(Map data) async {
    print(data);
    var response = await dio.patch(Endpoints.userProfile,data: data);
    print(response);
  }

  Future<List<Map<String, dynamic>>> getRestaurantData() async {
    var response = await dio.get(Endpoints.restaurantURL);
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

  Future<List<Map<String, dynamic>>> getNewsData() async {
    var response = await dio.get(Endpoints.newsURL);
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
    var res = await dio.post(Endpoints.claimItemURL,data:  {"id": id, "claimerEmail": email, "claimerName": name});
    return res.data;
  }

  Future<void> deleteBnsMyAd(String id, String email) async {
    await dio.post(Endpoints.deleteBuyURL,
        data: {'id': id, 'email': email});
    await dio.post(Endpoints.deleteSellURL,
        data: {'id': id, 'email': email});
  }

  Future<void> deleteLnfMyAd(String id, String email) async {
    await dio.post(Endpoints.deleteLostURL,
        data: {'id': id, 'email': email});
    await dio.post(Endpoints.deleteFoundURL,
        data: {'id': id, 'email': email});
  }

  Future<List> getBuyItems() async {
    //var res = await http.get(Uri.parse(Endpoints.buyURL));
    var response = await dio.get(Endpoints.buyURL);
    // var lostItemsDetails = jsonDecode(res.body);
    // return lostItemsDetails["details"];
    print(response.data);
    return response.data.details;
  }

  Future<List> getSellItems() async {
    var res = await dio.get(Endpoints.sellURL);
    return res.data.details;
  }

  Future<List<BuyModel>> getBnsMyItems(String mail) async {
    print("here in function");
    var res = await dio.post(Endpoints.bnsMyAdsURL,data: {'email': mail});
    print(res.data);
    var myItemsDetails = res.data;
    var sellList = (myItemsDetails["details"]["sellList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    var buyList = (myItemsDetails["details"]["buyList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return [...sellList, ...buyList];
  }

  Future<List<dynamic>> getLnfMyItems(String mail) async {
    print("here");
    var res = await dio.post(Endpoints.lnfMyAdsURL,data: {'email': mail});
    print(res);
    var myItemsDetails = res.data;
    var foundList = (myItemsDetails["details"]["foundList"] as List)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    var lostList = (myItemsDetails["details"]["lostList"] as List)
        .map((e) => LostModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return [...foundList, ...lostList];
  }

  Future<List> getLostItems() async {
    var res = await dio.get(Endpoints.lostURL);
    var lostItemsDetails = res.data;
    return lostItemsDetails["details"];
  }

  Future<List<LostModel>> getLostPage(int pageNumber) async {
    print("hre");
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    // final uri =
    //     Uri.https('swc.iitg.ac.in', Endpoints.lostPath, queryParameters);
    var response = await dio.get(Endpoints.lostPath,queryParameters: queryParameters);
    print(response);
    var json = response.data;
    print(json);
    List<LostModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => LostModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  Future<List<FoundModel>> getFoundPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    // final uri =
    //     Uri.https('swc.iitg.ac.in', Endpoints.foundPath, queryParameters);
    var response = await dio.get(Endpoints.foundPath,queryParameters: queryParameters);
    var json = response.data;
    List<FoundModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  Future<List<BuyModel>> getSellPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    // final uri =
    //     Uri.https('swc.iitg.ac.in', Endpoints.sellPath, queryParameters);
    var response = await dio.get(Endpoints.sellPath,queryParameters: queryParameters);
    var json = response.data;
    List<BuyModel> sellPage = (json['details'] as List<dynamic>)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return sellPage;
  }

  Future<List<SellModel>> getBuyPage(int pageNumber) async {
    print(pageNumber);
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    //final uri = Uri.https('swc.iitg.ac.in', Endpoints.buyPath, queryParameters);
    var response = await dio.get(Endpoints.sellPath,queryParameters: queryParameters);
    print(response);
    var json = response.data;
    List<SellModel> buyPage = (json['details'] as List<dynamic>)
        .map((e) => SellModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return buyPage;
  }

  Future<List> getFoundItems() async {
    var res = await dio.get(Endpoints.foundURL);
    var foundItemsDetails = res.data;
    return foundItemsDetails["details"];
  }

  Future<Map<String, dynamic>> postSellData(
      Map<String, String> data) async {
    var res = await dio.post(
      Endpoints.sellURL,
      data: {
        'title': data['title'],
        'description': data['description'],
        'price': data['price'],
        'imageString': data['image'],
        'phonenumber': data['contact'],
        'email': data['email'],
        'username': data['name']
      }
    );
    return res.data;
  }

  Future<Map<String, dynamic>> postBuyData(
      Map<String, String> data) async {
    var res = await dio.post(
      Endpoints.buyURL,
      data: {
        'title': data['title'],
        'description': data['description'],
        'price': data['total_price'],
        'imageString': data['image'],
        'phonenumber': data['contact'],
        'email': data['email'],
        'username': data['name']
      }
    );
    return res.data;
  }

  Future<Map<String, dynamic>> postLostData(
      Map<String, String> data) async {
    var res = await dio.post(Endpoints.lostURL,
        data: {
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

  Future<Map<String, dynamic>> postFoundData(
      Map<String, String> data) async {
    var res = await dio.post(Endpoints.foundURL,
        data: {
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
    var response =
        await dio.get(Endpoints.lastUpdatedURL);
    var status = response.statusCode;
    var body = response.data;
    print(body);
    if (status == 200) {
      Map<String, dynamic> data = body;
      return data;
    } else {
      throw Exception("Data could not be fetched");
    }
  }

  Future<List<Map<String, dynamic>>> getContactData() async {
    var response = await dio.get(Endpoints.contactURL);
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

  Future<Map<String, List<List<String>>>> getBusData() async {
    var response = await dio.get(Endpoints.busURL);
    var status = response.statusCode;
    var json = response.data;
    if (status == 200) {
      Map<String, List<List<String>>> answer = {};
      for (String stop in json.keys) {
        List<List<String>> time = [];
        time.add((json[stop]["CollegeToCity_Holiday"] as List<dynamic>)
            .map((e) => e as String)
            .toList());
        time.add((json[stop]["CollegeToCity_WorkingDay"] as List<dynamic>)
            .map((e) => e as String)
            .toList());

        time.add((json[stop]["CityToCollege_Holiday"] as List<dynamic>)
            .map((e) => e as String)
            .toList());
        time.add((json[stop]["CityToCollege_WorkingDay"] as List<dynamic>)
            .map((e) => e as String)
            .toList());
        answer[stop] = time;
      }
      return answer;
    } else {
      throw Exception("Bus Data could not be fetched");
    }
  }

  Future<List<Map<String, dynamic>>> getFerryData() async {
    var response = await dio.get(Endpoints.ferryURL);
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

  Future<RegisteredCourses> getTimeTable({required String roll}) async {
    final response = await dio.post(Endpoints.timetableURL,
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
    var response = await dio.get(Endpoints.messURL);
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
    final response = await dio.get(
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

  Future<Map<String, dynamic>> postUPSP(
      Map<String, dynamic> data) async {
    var res = await dio.post(Endpoints.upspPost,
        data: data);
    return res.data;
  }

  Future<String?> uploadFileToServer(File file) async {
    var fileName = file.path.split('/').last;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    try {
      var response = await dio.post(
        Endpoints.uploadFileUPSP,
        options: Options(
          contentType: 'multipart/form-data'
        ),
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

  static Future<void> createUser(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final res = await http.post(
      Uri.parse('https://swc.iitg.ac.in/onestopapi/v2/onestop-user'),
      body: jsonEncode(
        {
          "name": prefs.getString('name'),
          "email": prefs.getString('email'),
          "deviceToken": token
        },
      ),
       headers: {
        'Content-Type': 'application/json',
        'security-key': Endpoints.apiSecurityKey
      },
    );

  }

  Future<List<TravelTiming>> getFerryTiming() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print("FERRY TIMINGS");
      late String jsonData;

      if (prefs.getString('ferryTimings') != null) {
        jsonData = prefs.getString('ferryTimings') ?? '';
        print(jsonData);
      } else {

        final res = await dio.get(Endpoints.ferryURL);

        prefs.setString('ferryTimings', res.data);
        jsonData = prefs.getString('ferryTimings') ?? '';
        print(res.data);
        jsonData=res.data.toString();
        print(jsonData);
      }
      List<dynamic> ferryTiming = json.decode(jsonData)['data'];
      List<TravelTiming> ferryTimings = [];

      for (var element in ferryTiming) {
        ferryTimings.add(TravelTiming.fromJson(element));
      }
      return ferryTimings;

    } catch (e) {
      rethrow;
    }
  }

  Future<MealType> getMealData(String hostel, String day, String mealType,) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      late String jsonData;
      if (prefs.getString('messMenu') != null) {
        jsonData = prefs.getString('messMenu') ?? '';
      } else {
        final res = await dio.get(Endpoints.messURL);
        prefs.setString('messMenu', res.data.toString());

        jsonData = prefs.getString('messMenu') ?? res.data;
      }
      List<dynamic> answer = json.decode(jsonData)['details'];
      var meal = answer.firstWhere(
              (m) => m['hostel'].toString().trim().toLowerCase() ==
              hostel.toString().toLowerCase(),
          orElse: () => 'no data'
      );
      if(meal=='no data'){
        return MealType(
            id: '',
            mealDescription: 'Not updated by HMC',
            timing: 'Oh no!'
        );
      }
      return MealType(
          id: meal[day.trim().toLowerCase()][mealType.trim()
              .toLowerCase()]['_id'],
          mealDescription: meal[day.trim().toLowerCase()][mealType.trim()
              .toLowerCase()]['mealDescription'],
          timing: meal[day.trim().toLowerCase()][mealType.trim()
              .toLowerCase()]['timing']
      );
    }catch(e){
      print(Endpoints.messURL);
      print(e);
      rethrow;
    }
  }
  Future<List<TravelTiming>> getBusTiming() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      late String jsonData;

      if (prefs.getString('busTimings') != null) {
        jsonData = prefs.getString('busTimings') ?? '';
      } else {
        final res = await dio.get(Endpoints.busStops);
        prefs.setString('busTimings', res.data);
        jsonData=res.data;
        jsonData = prefs.getString('busTimings') ?? '';
      }
      List<dynamic> busTiming = json.decode(jsonData)['data'];
      List<TravelTiming> busTimings = [];
      for (var element in busTiming) {
        busTimings.add(TravelTiming.fromJson(element));
      }
      return busTimings;
    } catch (e) {
      print("____________________________________________");
      print(e);
      rethrow;
    }
  }
}
