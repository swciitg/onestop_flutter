import 'dart:convert';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';

class APIService {
  static String restaurantURL =
      "https://swc.iitg.ac.in/onestopapi/getAllOutlets";
  static String lastUpdatedURL =
      "https://swc.iitg.ac.in/onestopapi/lastDataUpdate";
  static String contactURL = "https://swc.iitg.ac.in/onestopapi/getContacts";
  static String timetableURL =
      "https://onestopiitgtimetable.herokuapp.com/get-my-courses";
  static String ferryURL = 'https://swc.iitg.ac.in/onestopapi/ferryTimings';
  static String busURL = 'https://swc.iitg.ac.in/onestopapi/busTimings';
  static String messURL = "https://swc.iitg.ac.in/onestopapi/hostelsMessMenu";

  static Future<List<Map<String, dynamic>>> getRestaurantData() async {
    http.Response response = await http.get(Uri.parse(restaurantURL));
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

  static Future<Map<String,dynamic>> postSellData(Map<String, String> data) async {
    var res =
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/sell"),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'price': data['price'],
              'imageString': data['image'],
              'phonenumber': data['contact'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json'});
    return jsonDecode(res.body);
  }

  static Future<Map<String,dynamic>> postBuyData(Map<String, String> data) async {
    var res =
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/buy"),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'price': data['total_price'],
              'imageString': data['image'],
              'phonenumber': data['contact'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json'});
    return  jsonDecode(res.body);
  }

  static Future<Map<String,dynamic>> postLostData(Map<String, String> data) async {
    var res =
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/lost"),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'location': data['location'],
              'imageString': data['image'],
              'phonenumber': data['contact'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json'});
    return  jsonDecode(res.body);
  }

  static Future<Map<String,dynamic>> postFoundData(Map<String, String> data) async {
    var res =
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/found"),
            body: jsonEncode({
              'title': data['title'],
              'description': data['description'],
              'location': data['location'],
              'imageString': data['image'],
              'submittedat': data['submittedAt'],
              'email': data['email'],
              'username': data['name']
            }),
            headers: {'Content-Type': 'application/json'});
    return  jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getLastUpdated() async {
    http.Response response = await http.get(Uri.parse(lastUpdatedURL));
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
    http.Response response = await http.get(Uri.parse(contactURL));
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

  static Future<List<List<String>>> getBusData() async {
    http.Response response = await http.get(Uri.parse(busURL));
    var status = response.statusCode;
    var json = jsonDecode(response.body);
    if (status == 200) {
      List<List<String>> time = [];
      time.add((json["CollegeToCity_Holiday"] as List<dynamic>)
          .map((e) => e as String)
          .toList());
      time.add((json["CollegeToCity_WorkingDay"] as List<dynamic>)
          .map((e) => e as String)
          .toList());

      time.add((json["CityToCollege_Holiday"] as List<dynamic>)
          .map((e) => e as String)
          .toList());
      time.add((json["CityToCollege_WorkingDay"] as List<dynamic>)
          .map((e) => e as String)
          .toList());
      return time;
    } else {
      throw Exception("Bus Data could not be fetched");
    }
  }

  static Future<List<Map<String, dynamic>>> getFerryData() async {
    http.Response response = await http.get(Uri.parse(ferryURL));
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
      Uri.parse(timetableURL),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
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
    http.Response response = await http.get(Uri.parse(messURL));
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
