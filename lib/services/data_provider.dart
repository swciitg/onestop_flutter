import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/models/news/news_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/local_storage.dart';

class DataProvider {
  static Future<Map<String, dynamic>?> getLastUpdated() async {
    var cachedData = await LocalStorage.instance.getRecord(DatabaseRecords.lastUpdated);
    if (cachedData == null) {
      return null;
    }
    return cachedData[0] as Map<String, dynamic>;
  }

  static Future<Map<String, List<List<String>>>> getBusTimings() async {
    var cachedData = await LocalStorage.instance.getBusRecord(DatabaseRecords.busTimings);
    if (cachedData == null) {
      print("NO BUS CACHED DATA");
      Map<String, List<List<String>>> busTime = await APIService().getBusData();
      print(busTime);
      await LocalStorage.instance.storeBusData(busTime, DatabaseRecords.busTimings);
      return busTime;
    }
    print("BUS CACHED DATA");
    Map<String, List<List<String>>> timings = {};
    for (String key in cachedData.keys) {
      timings[key] = (cachedData[key] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as String).trim()).toList())
          .toList();
    }
    return timings;
  }

  static Future<List<RestaurantModel>> getRestaurants() async {
    var cachedData = await LocalStorage.instance.getRecord(DatabaseRecords.restaurant);

    if (cachedData == null) {
      List<Map<String, dynamic>> restaurantData =
          await APIService().getRestaurantData();

      List<RestaurantModel> restaurants =
          restaurantData.map((e) => RestaurantModel.fromJson(e)).toList();

      await LocalStorage.instance.storeData(restaurantData, DatabaseRecords.restaurant);

      return restaurants;
    }

    return cachedData
        .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<NewsModel>> getNews() async {
    List<Map<String, dynamic>> newsData = await APIService().getNewsData();
    List<NewsModel> news = newsData.map((e) => NewsModel.fromJson(e)).toList();
    return news;
  }

  static Future<RegisteredCourses> getTimeTable({required String roll}) async {
    var cachedData = (await LocalStorage.instance.getRecord(DatabaseRecords.timetable))?[0];
    if (cachedData == null) {
      RegisteredCourses timetableData =
          await APIService().getTimeTable(roll: roll);
      await LocalStorage.instance
          .storeData([timetableData.toJson()], DatabaseRecords.timetable);
      return timetableData;
    }
    // TODO: Change this later, for now cache till the end of Monsoon sem
    DateTime semEnd = DateTime.parse("2022-12-23");
    if (DateTime.now().isBefore(semEnd)) {
      return RegisteredCourses.fromJson(cachedData as Map<String, dynamic>);
    }
    return (await APIService().getTimeTable(roll: roll));
  }

  static Future<SplayTreeMap<String, ContactModel>> getContacts() async {
    var cachedData = await LocalStorage.instance.getRecord(DatabaseRecords.contacts);
    SplayTreeMap<String, ContactModel> people = SplayTreeMap();

    if (cachedData == null) {
      List<Map<String, dynamic>> contactData =
          await APIService().getContactData();
      for (var element in contactData) {
        people[element['name']] = ContactModel.fromJson(element);
      }
      await LocalStorage.instance.storeData(contactData, DatabaseRecords.contacts);
      return people;
    }
    for (var element in cachedData) {
      var x = element as Map<String, dynamic>;
      people[x['name']] = ContactModel.fromJson(x);
    }
    return people;
  }



}
