import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/food/mess_menu_model.dart';
import '../models/travel/travel_timing_model.dart';

class APIService {
  static Future<bool> postFeedbackData(Map<String, String> data) async {
    String tag = data['type'] == 'Issue Report' ? 'bug' : 'enhancement';
    String newBody =
        "### Description :\n${data['body']}\n### Posted By :\n${data['user']}";
    var res = await http.post(Uri.parse(Endpoints.feedback),
        body: jsonEncode({
          'title': data['title'],
          'body': newBody,
          'labels': [tag]
        }),
        headers: {
          'Accept': 'application/vnd.github+json',
          'Authorization': 'Bearer ${Endpoints.githubIssueToken}'
        });
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  static Future<List<Map<String, dynamic>>> getRestaurantData() async {
    http.Response response = await http.get(Uri.parse(Endpoints.restaurantURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
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

  static Future<List<Map<String, dynamic>>> getNewsData() async {
    http.Response response = await http.get(Uri.parse(Endpoints.newsURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
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

  static Future<dynamic> claimFoundItem(
      {required String name, required String email, required String id}) async {
    var res = await http.post(Uri.parse(Endpoints.claimItemURL),
        headers: Endpoints.getHeader(),
        body:
            jsonEncode({"id": id, "claimerEmail": email, "claimerName": name}));
    return jsonDecode(res.body);
  }

  static Future<void> deleteBnsMyAd(String id, String email) async {
    await http.post(Uri.parse(Endpoints.deleteBuyURL),
        headers: Endpoints.getHeader(),
        body: jsonEncode({'id': id, 'email': email}));
    await http.post(Uri.parse(Endpoints.deleteSellURL),
        headers: Endpoints.getHeader(),
        body: jsonEncode({'id': id, 'email': email}));
  }

  static Future<void> deleteLnfMyAd(String id, String email) async {
    await http.post(Uri.parse(Endpoints.deleteLostURL),
        headers: Endpoints.getHeader(),
        body: jsonEncode({'id': id, 'email': email}));
    await http.post(Uri.parse(Endpoints.deleteFoundURL),
        headers: Endpoints.getHeader(),
        body: jsonEncode({'id': id, 'email': email}));
  }

  static Future<List> getBuyItems() async {
    var res = await http.get(Uri.parse(Endpoints.buyURL));
    var lostItemsDetails = jsonDecode(res.body);
    return lostItemsDetails["details"];
  }

  static Future<List> getSellItems() async {
    var res = await http.get(Uri.parse(Endpoints.sellURL));
    var foundItemsDetails = jsonDecode(res.body);
    return foundItemsDetails["details"];
  }

  static Future<List<BuyModel>> getBnsMyItems(String mail) async {
    var res = await http.post(Uri.parse(Endpoints.bnsMyAdsURL),
        headers: Endpoints.getHeader(), body: jsonEncode({'email': mail}));

    var myItemsDetails = jsonDecode(res.body);
    var sellList = (myItemsDetails["details"]["sellList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    var buyList = (myItemsDetails["details"]["buyList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return [...sellList, ...buyList];
  }

  static Future<List<dynamic>> getLnfMyItems(String mail) async {
    var res = await http.post(Uri.parse(Endpoints.lnfMyAdsURL),
        headers: Endpoints.getHeader(), body: jsonEncode({'email': mail}));

    var myItemsDetails = jsonDecode(res.body);
    var foundList = (myItemsDetails["details"]["foundList"] as List)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    var lostList = (myItemsDetails["details"]["lostList"] as List)
        .map((e) => LostModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return [...foundList, ...lostList];
  }

  static Future<List> getLostItems() async {
    var res = await http.get(Uri.parse(Endpoints.lostURL));
    var lostItemsDetails = jsonDecode(res.body);
    return lostItemsDetails["details"];
  }

  static Future<List<LostModel>> getLostPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri =
        Uri.https('swc.iitg.ac.in', Endpoints.lostPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<LostModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => LostModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  static Future<List<FoundModel>> getFoundPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri =
        Uri.https('swc.iitg.ac.in', Endpoints.foundPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<FoundModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  static Future<List<BuyModel>> getSellPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri =
        Uri.https('swc.iitg.ac.in', Endpoints.sellPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<BuyModel> sellPage = (json['details'] as List<dynamic>)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return sellPage;
  }

  static Future<List<SellModel>> getBuyPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri = Uri.https('swc.iitg.ac.in', Endpoints.buyPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<SellModel> buyPage = (json['details'] as List<dynamic>)
        .map((e) => SellModel.fromJson(e))
        .toList();
    await Future.delayed(const Duration(milliseconds: 300), () => null);
    return buyPage;
  }

  static Future<List> getFoundItems() async {
    var res = await http.get(Uri.parse(Endpoints.foundURL));
    var foundItemsDetails = jsonDecode(res.body);
    return foundItemsDetails["details"];
  }

  static Future<Map<String, dynamic>> postSellData(
      Map<String, String> data) async {
    var res = await http.post(
      Uri.parse(Endpoints.sellURL),
      body: jsonEncode({
        'title': data['title'],
        'description': data['description'],
        'price': data['price'],
        'imageString': data['image'],
        'phonenumber': data['contact'],
        'email': data['email'],
        'username': data['name']
      }),
      headers: Endpoints.getHeader(),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> postBuyData(
      Map<String, String> data) async {
    var res = await http.post(
      Uri.parse(Endpoints.buyURL),
      body: jsonEncode({
        'title': data['title'],
        'description': data['description'],
        'price': data['total_price'],
        'imageString': data['image'],
        'phonenumber': data['contact'],
        'email': data['email'],
        'username': data['name']
      }),
      headers: Endpoints.getHeader(),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> postLostData(
      Map<String, String> data) async {
    var res = await http.post(Uri.parse(Endpoints.lostURL),
        body: jsonEncode({
          'title': data['title'],
          'description': data['description'],
          'location': data['location'],
          'imageString': data['image'],
          'phonenumber': data['contact'],
          'email': data['email'],
          'username': data['name']
        }),
        headers: Endpoints.getHeader());
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> postFoundData(
      Map<String, String> data) async {
    var res = await http.post(Uri.parse(Endpoints.foundURL),
        body: jsonEncode({
          'title': data['title'],
          'description': data['description'],
          'location': data['location'],
          'imageString': data['image'],
          'submittedat': data['submittedAt'],
          'email': data['email'],
          'username': data['name']
        }),
        headers: Endpoints.getHeader());
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getLastUpdated() async {
    http.Response response =
        await http.get(Uri.parse(Endpoints.lastUpdatedURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
    if (status == 200) {
      Map<String, dynamic> data = body;
      return data;
    } else {
      throw Exception("Data could not be fetched");
    }
  }

  static Future<List<Map<String, dynamic>>> getContactData() async {
    http.Response response = await http.get(Uri.parse(Endpoints.contactURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
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

  static Future<Map<String, List<List<String>>>> getBusData() async {
    http.Response response = await http.get(Uri.parse(Endpoints.busURL));
    var status = response.statusCode;
    var json = jsonDecode(response.body);
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

  static Future<List<Map<String, dynamic>>> getFerryData() async {
    http.Response response = await http.get(Uri.parse(Endpoints.ferryURL));
    var status = response.statusCode;
    var json = jsonDecode(response.body);
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

  static Future<RegisteredCourses> getTimeTable({required String roll}) async {
    final response = await http.post(
      Uri.parse(Endpoints.timetableURL),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'security-key': Endpoints.apiSecurityKey
      },
      body: jsonEncode({
        "roll_number": roll,
      }),
    );
    if (response.statusCode == 200) {
      return RegisteredCourses.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<Map<String, dynamic>>> getMessMenu() async {
    http.Response response = await http.get(Uri.parse(Endpoints.messURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
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

  static Future<List<LatLng>> getPolyline(
      {required LatLng source, required LatLng dest}) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248b144cc92443247b7b9e0bd5df85012f2&start=8.681495,49.41461&end=8.687872,49.420318'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<LatLng> res = [];
      for (var r in body['features'][0]['geometry']['coordinates']) {
        res.add(LatLng(r[0], r[1]));
      }
      return res;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Map<String, dynamic>> postUPSP(
      Map<String, dynamic> data) async {
    var res = await http.post(Uri.parse(Endpoints.upspPost),
        body: jsonEncode(data), headers: Endpoints.getHeader());
    return jsonDecode(res.body);
  }

  static Future<String?> uploadFileToServer(File file) async {
    var fileName = file.path.split('/').last;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    try {
      var response = await Dio().post(
        Endpoints.uploadFileUPSP,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'security-key': Endpoints.apiSecurityKey},
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
    } on DioError {
      return null;
    }
  }

  static Future<List<TravelTiming>> getFerryTiming() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      late String jsonData;

      if (prefs.getString('ferryTimings') != null) {
        jsonData = prefs.getString('ferryTimings') ?? '';
      } else {

        final res = await http.get(
          Uri.parse(Endpoints.ferryURL),
          headers: Endpoints.getHeader(),
        );

        prefs.setString('ferryTimings', res.body);
        jsonData = prefs.getString('ferryTimings') ?? '';
        jsonData=res.body;
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
  static Future<MealType> getMealData(String hostel, String day, String mealType,) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      late String jsonData;
      if (prefs.getString('messMenu') != null) {
        jsonData = prefs.getString('messMenu') ?? '';
      } else {
        final res = await http.get(
          Uri.parse(Endpoints.messURL),
          headers: Endpoints.getHeader(),
        );
        prefs.setString('messMenu', res.body);

        jsonData = prefs.getString('messMenu') ?? res.body;
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
      rethrow;
    }

  }
  static Future<List<TravelTiming>> getBusTiming() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      late String jsonData;

      if (prefs.getString('busTimings') != null) {
        jsonData = prefs.getString('busTimings') ?? '';
      } else {
        final res = await http.get(
          Uri.parse(Endpoints.busURL),
          headers: Endpoints.getHeader(),
        );
        prefs.setString('busTimings', res.body);
        jsonData=res.body;
        jsonData = prefs.getString('busTimings') ?? '';
      }
      List<dynamic> busTiming = json.decode(jsonData)['data'];
      List<TravelTiming> busTimings = [];
      for (var element in busTiming) {
        busTimings.add(TravelTiming.fromJson(element));
      }
      return busTimings;
    } catch (e) {

      rethrow;
    }
  }
}
