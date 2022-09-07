import 'dart:convert';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/models/timetable/registered_courses.dart';

class APIService {
  static String restaurantURL =
      "https://swc.iitg.ac.in/onestopapi/v2/getAllOutlets";
  static String lastUpdatedURL =
      "https://swc.iitg.ac.in/onestopapi/v2/lastDataUpdate";
  static String contactURL = "https://swc.iitg.ac.in/onestopapi/v2/getContacts";
  static String timetableURL =
      "https://onestopiitgtimetable.herokuapp.com/get-my-courses";
  static String ferryURL = 'https://swc.iitg.ac.in/onestopapi/v2/ferryTimings';
  static String busURL = 'https://swc.iitg.ac.in/onestopapi/v2/busTimings';
  static String messURL = "https://swc.iitg.ac.in/onestopapi/v2/hostelsMessMenu";
  static String buyURL = 'https://swc.iitg.ac.in/onestopapi/v2/buy';
  static String sellURL = 'https://swc.iitg.ac.in/onestopapi/v2/sell';
  static String myAdsURL = 'https://swc.iitg.ac.in/onestopapi/v2/myads';
  static String lostURL = 'https://swc.iitg.ac.in/onestopapi/v2/lost';
  static String foundURL = 'https://swc.iitg.ac.in/onestopapi/v2/found';
  static const apiSecurityKey = String.fromEnvironment('SECURITY-KEY');

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

  static Future<dynamic> claimFoundItem(
      {required String name, required String email, required String id}) async {
    var res = await http.post(
        Uri.parse("https://swc.iitg.ac.in/onestopapi/v2/found/claim"),
        headers: {
          'Content-Type': 'application/json',
          'security-key': apiSecurityKey
        },
        body:
            jsonEncode({"id": id, "claimerEmail": email, "claimerName": name}));
    return jsonDecode(res.body);
  }

  static Future<void> deleteMyAd(String id, String email) async {
    await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/v2/buy/remove"),
        headers: {
      'Content-Type': 'application/json',
          'security-key': apiSecurityKey},
        body: jsonEncode({'id': id, 'email': email}));
    await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/v2/sell/remove"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'email': email}));
  }

  static Future<List> getBuyItems() async {
    var res = await http.get(Uri.parse(buyURL));
    var lostItemsDetails = jsonDecode(res.body);
    return lostItemsDetails["details"];
  }

  static Future<List> getSellItems() async {
    var res = await http.get(Uri.parse(sellURL));
    var foundItemsDetails = jsonDecode(res.body);
    return foundItemsDetails["details"];
  }

  static Future<List> getMyItems(String mail) async {
    var res = await http.post(Uri.parse(myAdsURL),
        headers: {
      'Content-Type': 'application/json',
      'security-key': apiSecurityKey
        },
        body: jsonEncode({'email': mail}));

    var myItemsDetails = jsonDecode(res.body);
    return [
      ...myItemsDetails["details"]["sellList"],
      ...myItemsDetails["details"]["buyList"]
    ];
  }

  static Future<List> getLostItems() async {
    var res = await http.get(Uri.parse(lostURL));
    var lostItemsDetails = jsonDecode(res.body);
    return lostItemsDetails["details"];
  }

  static Future<List> getFoundItems() async {
    var res = await http.get(Uri.parse(foundURL));
    var foundItemsDetails = jsonDecode(res.body);
    return foundItemsDetails["details"];
  }

  static Future<Map<String, dynamic>> postSellData(
      Map<String, String> data) async {
    var res =
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/v2/sell"),
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
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/v2/buy"),
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
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/v2/lost"),
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
        await http.post(Uri.parse("https://swc.iitg.ac.in/onestopapi/v2/found"),
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
