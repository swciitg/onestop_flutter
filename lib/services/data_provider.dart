import 'dart:async';
import 'dart:collection';

import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/models/news/news_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/models/travel/ferry_data_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/local_storage.dart';

class DataProvider {
  static Future<Map<String, dynamic>?> getLastUpdated() async {
    var cachedData = await LocalStorage.instance.getRecord("LastUpdated");
    if (cachedData == null) {
      return null;
    }
    return cachedData[0] as Map<String, dynamic>;
  }

  static Future<Map<String,List<List<String>>>> getBusTimings() async {
    var cachedData = await LocalStorage.instance.getBusRecord("BusTimings");
    if (cachedData == null) {
      Map<String,List<List<String>>> busTime = await APIService.getBusData();
      await LocalStorage.instance.storeBusData(busTime, "BusTimings");
      return busTime;
    }
    Map<String,List<List<String>>> timings = {};
    for(String key in cachedData.keys)
      {
        timings[key] = (cachedData[key] as List<dynamic>)
            .map((e) => (e as List<dynamic>).map((e) => (e as String).trim()).toList())
            .toList();
      }
    return timings;
  }

  static Future<List<RestaurantModel>> getRestaurants() async {
    var cachedData = await LocalStorage.instance.getRecord("Restaurant");

    if (cachedData == null) {
      List<Map<String, dynamic>> restaurantData =
          await APIService.getRestaurantData();

      List<RestaurantModel> restaurants =
          restaurantData.map((e) => RestaurantModel.fromJson(e)).toList();

      await LocalStorage.instance.storeData(restaurantData, "Restaurant");

      return restaurants;
    }

    return cachedData
        .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<NewsModel>> getNews() async {
      List<Map<String, dynamic>> newsData = await APIService.getNewsData();
      List<NewsModel> news = newsData.map((e) => NewsModel.fromJson(e)).toList();
      return news;
  }

  static Future<RegisteredCourses> getTimeTable({required String roll}) async {
    var cachedData = (await LocalStorage.instance.getRecord("Timetable"))?[0];
    if (cachedData == null) {
      RegisteredCourses timetableData = await APIService.getTimeTable(roll: roll);
      await LocalStorage.instance.storeData([timetableData.toJson()], "Timetable");
      return timetableData;
    }
    // TODO: Change this later, for now cache till the end of Monsoon sem
    DateTime semEnd = DateTime.parse("2022-12-23");
    if (DateTime.now().isBefore(semEnd)) {
      return RegisteredCourses.fromJson(cachedData as Map<String,dynamic>);
    }
    return (await APIService.getTimeTable(roll: roll));
  }


  static Future<SplayTreeMap<String, ContactModel>> getContacts() async {
    var cachedData = await LocalStorage.instance.getRecord("Contact");
    SplayTreeMap<String, ContactModel> people = SplayTreeMap();

    if (cachedData == null) {
      List<Map<String, dynamic>> contactData =
          await APIService.getContactData();
      for (var element in contactData) {
        people[element['name']] = ContactModel.fromJson(element);
      }
      await LocalStorage.instance.storeData(contactData, "Contact");
      return people;
    }
    for (var element in cachedData) {
      var x = element as Map<String, dynamic>;
      people[x['name']] = ContactModel.fromJson(x);
    }
    return people;
  }

  static Future<List<MessMenuModel>> getMessMenu() async {
    // return Future.delayed(Duration(seconds: 10),() => throw Exception("hello"));
    var cachedData = await LocalStorage.instance.getRecord("MessMenu");
    if (cachedData == null) {
      List<Map<String, dynamic>> messMenuData = await APIService.getMessMenu();
      List<MessMenuModel> answer =
          messMenuData.map((e) => MessMenuModel.fromJson(e)).toList();
      await LocalStorage.instance.storeData(messMenuData, "MessMenu");
      return answer;
    }
    List<MessMenuModel> answer = cachedData
        .map((e) => MessMenuModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return answer;
  }

  static Future<List<FerryTimeData>> getFerryTimings() async {
    var cachedData = await LocalStorage.instance.getRecord("FerryTimings");
    if (cachedData == null) {
      List<Map<String, dynamic>> ferryData = await APIService.getFerryData();
      await LocalStorage.instance.storeData(ferryData, "FerryTimings");
      List<FerryTimeData> answer =
          ferryData.map((e) => FerryTimeData.fromJson(e)).toList();
      return answer;
    }
    List<FerryTimeData> answer = [];

    for (var element in cachedData) {
      var x = element as Map<String, dynamic>;
      answer.add(FerryTimeData.fromJson(x));
    }
    return answer;
  }
}
