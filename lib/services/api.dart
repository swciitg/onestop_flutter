import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/models/timetable/registered_courses.dart';
class APIService {
  static String restaurantURL = "https://swc.iitg.ac.in/onestopapi/getAllOutlets";
  static String lastUpdatedURL = "https://swc.iitg.ac.in/onestopapi/lastDataUpdate";
  static String contactURL = "https://swc.iitg.ac.in/onestopapi/getContacts";
  static String timetableURL = "https://hidden-depths-09275.herokuapp.com/get-my-courses";
  static String ferryURL = 'https://swc.iitg.ac.in/onestopapi/ferrytimings';
  static String busURL = 'https://swc.iitg.ac.in/onestopapi/bustimings';
  static String messURL = "https://swc.iitg.ac.in/onestopapi/hostelsMessMenu";

  static Future<List<Map<String, dynamic>>> getRestaurantData() async {
    http.Response response = await http.get(Uri.parse(restaurantURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
    print("Sending GET request to $restaurantURL");
    if (status == 200) {
      List<Map<String, dynamic>> data = [];
      for (var json in body) {
        data.add(json);
      }
      return data;
    } else {
      print(status);
      throw Exception("Data could not be fetched");
    }
  }

  static Future<Map<String, dynamic>> getLastUpdated() async {
    http.Response response = await http.get(Uri.parse(lastUpdatedURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
    print("Sending GET request to $lastUpdatedURL");
    if (status == 200) {
      Map<String, dynamic> data = body;
      return data;
    } else {
      print(status);
      throw Exception("Data could not be fetched");
    }
  }

  static Future<List<Map<String, dynamic>>> getContactData() async {
    http.Response response = await http.get(Uri.parse(contactURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
    print("Sending GET request to $contactURL");
    if (status == 200)
    {
      List<Map<String, dynamic>> data = [];
      for (var json in body)
      {
        data.add(json);
      }
      return data;
    }
    else
    {
      print(status);
      throw Exception("contact Data could not be fetched");
    }
  }


  static Future<List<List<String>>> getBusData() async
  {
    String data = await rootBundle.loadString(busURL);
    var json = jsonDecode(data);
    List<List<String>>time = [];
    //print(json.runtimeType);
    time.add((json["CollegeToCity_Holiday"] as List<dynamic>).map((e) => e as String).toList());
    time.add((json["CollegeToCity_WorkingDay"] as List<dynamic>).map((e) => e as String).toList());

    time.add((json["CityToCollege_Holiday"] as List<dynamic>).map((e) => e as String).toList());
    time.add((json["CityToCollege_WorkingDay"] as List<dynamic>).map((e) => e as String).toList());
    print(time);
    return time;
  }

  static Future<List<Map<String,dynamic>>> getFerryData() async
  {
    String data = await rootBundle.loadString(ferryURL);
    var json = jsonDecode(data);
    List<Map<String,dynamic>>answer = [];
    print(json.runtimeType);
    for (var temp in json)
    {
      answer.add(temp);
    }
    print(answer);
    return answer;
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
      print(response.statusCode);
      throw Exception(response.statusCode);
    }
  }

  static Future<List<Map<String, dynamic>>> getMessMenu() async {
    http.Response response = await http.get(Uri.parse(messURL));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
    print("Sending GET request to $messURL");
    if (status == 200)
    {
      List<Map<String, dynamic>> data = [];
      for (var json in body)
      {
        data.add(json);
      }
      return data;
    }
    else
    {
      print(status);
      throw Exception("contact Data could not be fetched");
    }
  }

  static Future<List<LatLng>> getPolyline ({required LatLng source, required LatLng dest}) async {
    final response = await http.get(
      Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248b144cc92443247b7b9e0bd5df85012f2&start=8.681495,49.41461&end=8.687872,49.420318'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var body=jsonDecode(response.body);
      List<LatLng>res=[];
      for(var r in body['features'][0]['geometry']['coordinates']){
        res.add(LatLng(r[0], r[1]));
      }
      print(res);
      return res;
    } else {
      print(response.reasonPhrase);
      throw Exception(response.body);
    }
  }
}
