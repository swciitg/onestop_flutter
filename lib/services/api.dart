import 'dart:convert';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';

import 'package:onestop_dev/models/buy_sell/sell_model.dart';

class APIService {
  static const String _restaurantURL = "https://swc.iitg.ac.in/onestopapi/v2/getAllOutlets";
  static const String _lastUpdatedURL = "https://swc.iitg.ac.in/onestopapi/v2/lastDataUpdate";
  static const String _contactURL = "https://swc.iitg.ac.in/onestopapi/v2/getContacts";
  static const String _timetableURL = "https://swc.iitg.ac.in/smartTimetable/get-my-courses";
  static const String _ferryURL = 'https://swc.iitg.ac.in/onestopapi/v2/ferryTimings';
  static const String _busURL = 'https://swc.iitg.ac.in/onestopapi/v2/busTimings';
  static const String _messURL = "https://swc.iitg.ac.in/onestopapi/v2/hostelsMessMenu";
  static const String _buyURL = 'https://swc.iitg.ac.in/onestopapi/v2/buy';
  static const String _sellURL = 'https://swc.iitg.ac.in/onestopapi/v2/sell';
  static const String _sellPath = '/onestopapi/v2/sellPage';
  static const String _buyPath = '/onestopapi/v2/buyPage';
  static const String _myAdsURL = 'https://swc.iitg.ac.in/onestopapi/v2/myads';
  static const String _deleteBuyURL = "https://swc.iitg.ac.in/onestopapi/v2/buy/remove";
  static const String _deleteSellURL = "https://swc.iitg.ac.in/onestopapi/v2/sell/remove";
  static const String _lostURL = 'https://swc.iitg.ac.in/onestopapi/v2/lost';
  static const String _lostPath = '/onestopapi/v2/lostPage';
  static const String _foundPath = '/onestopapi/v2/foundPage';
  static const String _foundURL = 'https://swc.iitg.ac.in/onestopapi/v2/found';
  static const String _claimItemURL = "https://swc.iitg.ac.in/onestopapi/v2/found/claim";
  static const apiSecurityKey = String.fromEnvironment('SECURITY-KEY');

  static Future<List<Map<String, dynamic>>> getRestaurantData() async {
    http.Response response = await http.get(Uri.parse(_restaurantURL));
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
    var res = await http.post(
        Uri.parse(_claimItemURL),
        headers: {
          'Content-Type': 'application/json',
          'security-key': apiSecurityKey
        },
        body:
            jsonEncode({"id": id, "claimerEmail": email, "claimerName": name}));
    return jsonDecode(res.body);
  }

  static Future<void> deleteMyAd(String id, String email) async {
    await http.post(Uri.parse(_deleteBuyURL),
        headers: {
      'Content-Type': 'application/json',
          'security-key': apiSecurityKey},
        body: jsonEncode({'id': id, 'email': email}));
    await http.post(Uri.parse(_deleteSellURL),
        headers: {'Content-Type': 'application/json',
        'security-key': apiSecurityKey},
        body: jsonEncode({'id': id, 'email': email}));
  }

  static Future<List> getBuyItems() async {
    var res = await http.get(Uri.parse(_buyURL));
    var lostItemsDetails = jsonDecode(res.body);
    return lostItemsDetails["details"];
  }

  static Future<List> getSellItems() async {
    var res = await http.get(Uri.parse(_sellURL));
    var foundItemsDetails = jsonDecode(res.body);
    return foundItemsDetails["details"];
  }

  static Future<List<BuyModel>> getMyItems(String mail) async {
    var res = await http.post(Uri.parse(_myAdsURL),
        headers: {
      'Content-Type': 'application/json',
      'security-key': apiSecurityKey
        },
        body: jsonEncode({'email': mail}));

    var myItemsDetails = jsonDecode(res.body);
    var sellList = (myItemsDetails["details"]["sellList"] as List).map((e) => BuyModel.fromJson(e)).toList();
    var buyList = (myItemsDetails["details"]["buyList"] as List).map((e) => BuyModel.fromJson(e)).toList();
    return [
      ...sellList,
      ...buyList
    ];
  }

  static Future<List> getLostItems() async {
    var res = await http.get(Uri.parse(_lostURL));
    var lostItemsDetails = jsonDecode(res.body);
    return lostItemsDetails["details"];
  }

  static Future<List<LostModel>> getLostPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri = Uri.https('swc.iitg.ac.in', _lostPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<LostModel> lostPage = (json['details'] as List<dynamic>).map((e) => LostModel.fromJson(e)).toList();
    return lostPage;
  }

  static Future<List<FoundModel>> getFoundPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri = Uri.https('swc.iitg.ac.in', _foundPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<FoundModel> lostPage = (json['details'] as List<dynamic>).map((e) => FoundModel.fromJson(e)).toList();
    return lostPage;
  }

  static Future<List<BuyModel>> getSellPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri = Uri.https('swc.iitg.ac.in', _sellPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<BuyModel> sellPage = (json['details'] as List<dynamic>).map((e) => BuyModel.fromJson(e)).toList();
    return sellPage;
  }

  static Future<List<SellModel>> getBuyPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    final uri = Uri.https('swc.iitg.ac.in', _buyPath, queryParameters);
    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    List<SellModel> buyPage = (json['details'] as List<dynamic>).map((e) => SellModel.fromJson(e)).toList();
    return buyPage;
  }

  static Future<List> getFoundItems() async {
    var res = await http.get(Uri.parse(_foundURL));
    var foundItemsDetails = jsonDecode(res.body);
    return foundItemsDetails["details"];
  }

  static Future<Map<String, dynamic>> postSellData(
      Map<String, String> data) async {
    var res =
        await http.post(Uri.parse(_sellURL),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'price': data['price'],
              'imageString': data['image'],
              'phonenumber': data['contact'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json',
              'security-key': apiSecurityKey});
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> postBuyData(
      Map<String, String> data) async {
    var res =
        await http.post(Uri.parse(_buyURL),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'price': data['total_price'],
              'imageString': data['image'],
              'phonenumber': data['contact'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json',
              'security-key': apiSecurityKey});
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> postLostData(
      Map<String, String> data) async {
    var res =
        await http.post(Uri.parse(_lostURL),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'location': data['location'],
              'imageString': data['image'],
              'phonenumber': data['contact'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json',
              'security-key': apiSecurityKey});
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> postFoundData(
      Map<String, String> data) async {
    var res =
        await http.post(Uri.parse(_foundURL),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'location': data['location'],
              'imageString': data['image'],
              'submittedat': data['submittedAt'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json',
              'security-key': apiSecurityKey});
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getLastUpdated() async {
    http.Response response = await http.get(Uri.parse(_lastUpdatedURL));
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
    http.Response response = await http.get(Uri.parse(_contactURL));
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
    http.Response response = await http.get(Uri.parse(_busURL));
    var status = response.statusCode;
    var json = jsonDecode(response.body);
    if (status == 200) {
      Map<String, List<List<String>>> answer = {};
      for(String stop in json.keys)
        {
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
    http.Response response = await http.get(Uri.parse(_ferryURL));
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
      Uri.parse(_timetableURL),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'security-key': apiSecurityKey
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
    http.Response response = await http.get(Uri.parse(_messURL));
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
}
