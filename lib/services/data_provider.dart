import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/models/news/news_model.dart';
import 'package:onestop_dev/models/notifications/notification_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/local_storage.dart';

import '../models/travel/travel_timing_model.dart';

class DataProvider {
  static Future<Map<String, dynamic>?> getLastUpdated() async {
    var cachedData =
        await LocalStorage.instance.getRecord(DatabaseRecords.lastUpdated);
    if (cachedData == null) {
      return null;
    }
    return cachedData[0] as Map<String, dynamic>;
  }

  static Future<List<TravelTiming>> getBusTiming() async {
    var cachedData =
        await LocalStorage.instance.getRecord(DatabaseRecords.busTimings);
    print("BUS TIMINGS");
    Map<String, dynamic> jsonData;
    if (cachedData == null) {
      jsonData = await APIService().getBusTiming();
      await LocalStorage.instance
          .storeData([jsonData], DatabaseRecords.busTimings);
    } else {
      jsonData = cachedData[0] as Map<String, dynamic>;
    }
    List<dynamic> busData = jsonData['data'];
    print(busData);
    List<TravelTiming> busTimings = [];
    print("here before length");
    for (var element in busData) {
      busTimings.add(TravelTiming.fromJson(element));
    }
    if (busTimings.length == 0) {
      return busTimings;
    }
    for (int i = 0; i < busTimings[0].weekdays.toCampus.length; i++) {
      busTimings[0].weekdays.toCampus[i] =
          busTimings[0].weekdays.toCampus[i].toLocal();
      print(busTimings[0].weekdays.toCampus[i]);
    }
    for (int i = 0; i < busTimings[0].weekdays.fromCampus.length; i++) {
      busTimings[0].weekdays.fromCampus[i] =
          busTimings[0].weekdays.fromCampus[i].toLocal();
      print(busTimings[0].weekdays.fromCampus[i]);
    }
    for (int i = 0; i < busTimings[0].weekend.toCampus.length; i++) {
      busTimings[0].weekend.toCampus[i] =
          busTimings[0].weekend.toCampus[i].toLocal();
      print(busTimings[0].weekend.toCampus[i]);
    }
    for (int i = 0; i < busTimings[0].weekend.fromCampus.length; i++) {
      busTimings[0].weekend.fromCampus[i] =
          busTimings[0].weekend.fromCampus[i].toLocal();
      print(busTimings[0].weekend.fromCampus[i]);
    }
    print("here at length");
    print(busTimings.length);
    return busTimings;
  }

  static Future<List<RestaurantModel>> getRestaurants() async {
    var cachedData =
        await LocalStorage.instance.getRecord(DatabaseRecords.restaurant);

    if (cachedData == null) {
      print("INSIDE RESTRAURENTS GET");
      List<Map<String, dynamic>> restaurantData =
          await APIService().getRestaurantData();
      print(restaurantData);
      List<RestaurantModel> restaurants =
          restaurantData.map((e) => RestaurantModel.fromJson(e)).toList();

      await LocalStorage.instance
          .storeData(restaurantData, DatabaseRecords.restaurant);

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
    var cachedData = null;
    //(await LocalStorage.instance.getRecord(DatabaseRecords.timetable))?[0];
    if (cachedData == null) {
      RegisteredCourses timetableData =
          await APIService().getTimeTable(roll: roll);
      print(timetableData.courses![0].endsem);
      // await LocalStorage.instance
      //     .storeData([timetableData.toJson()], DatabaseRecords.timetable);
      return timetableData;
    }
    // TODO: Change this later, for now cache till the end of Monsoon sem
    DateTime semEnd = DateTime.parse("2023-01-01T09:00:00.000Z");
    if (DateTime.now().isBefore(semEnd)) {
      return RegisteredCourses.fromJson(cachedData as Map<String, dynamic>);
    }
    return (await APIService().getTimeTable(roll: roll));
  }

  static Future<MealType> getMealData({
    required String hostel,
    required String day,
    required String mealType,
  }) async {
    var cachedData =
        (await LocalStorage.instance.getRecord(DatabaseRecords.messMenu))?[0];
    Map<String, dynamic>? jsonData;

    if (cachedData == null) {
      jsonData = await APIService().getMealData();
      LocalStorage.instance.storeData([jsonData], DatabaseRecords.messMenu);
    } else {
      jsonData = cachedData as Map<String, dynamic>;
    }

    List<dynamic> answer = jsonData['details']!;
    var meal = answer.firstWhere(
        (m) =>
            m['hostel'].toString().trim().toLowerCase() ==
            hostel.toString().toLowerCase(),
        orElse: () => 'no data');
    if (meal == 'no data') {
      return MealType(
          id: '',
          mealDescription:
              "Not updated by ${hostel}'s HMC. Kindly Contact ask them to update",
          startTiming: DateTime.now(),
          endTiming: DateTime.now());
    }
    return MealType(
        id: meal[day.trim().toLowerCase()][mealType.trim().toLowerCase()]
            ['_id'],
        mealDescription: meal[day.trim().toLowerCase()]
            [mealType.trim().toLowerCase()]['mealDescription'],
        startTiming: DateTime.parse(
          meal[day.trim().toLowerCase()][mealType.trim().toLowerCase()]
              ['startTiming'],
        ).toLocal(),
        endTiming: DateTime.parse(meal[day.trim().toLowerCase()]
                [mealType.trim().toLowerCase()]['endTiming'])
            .toLocal());
  }

  static Future<SplayTreeMap<String, ContactModel>> getContacts() async {
    var cachedData =
        await LocalStorage.instance.getRecord(DatabaseRecords.contacts);
    SplayTreeMap<String, ContactModel> people = SplayTreeMap();
    if (cachedData == null) {
      List<Map<String, dynamic>> contactData =
          await APIService().getContactData();
      print("GET CONTACT DATA");
      print(contactData);
      for (var element in contactData) {
        people[element['sectionName']] = ContactModel.fromJson(element);
        print("HERE NFJ");
      }
      await LocalStorage.instance
          .storeData(contactData, DatabaseRecords.contacts);
      return people;
    } else {
      for (var element in cachedData) {
        var x = element as Map<String, dynamic>;
        people[x['sectionName']] = ContactModel.fromJson(x);
      }
      return people;
    }
  }

  static Future<Map<String, List<NotifsModel>>> getNotifications() async {
    var response = await APIService().getNotifications();
    Map<String, List<NotifsModel>> output = {
      "userPersonalNotifs": [],
      "allTopicNotifs": []
    };

    for (var notif in response[0].data["allTopicNotifs"]!) {
      print(notif);
      output["allTopicNotifs"]!.add(NotifsModel.fromJson(notif));
    }
    for (var notif in response[1].data["userPersonalNotifs"]!) {
      print(notif);
      output["userPersonalNotifs"]!.add(NotifsModel.fromJson(notif));
    }
    print("here");
    return output;
  }

  static Future<List<TravelTiming>> getFerryTiming() async {
    var cachedData =
        await LocalStorage.instance.getRecord(DatabaseRecords.ferryTimings);
    print("FERRY TIMINGS");
    Map<String, dynamic> jsonData;
    if (cachedData == null) {
      jsonData = await APIService().getFerryTiming();
      await LocalStorage.instance
          .storeData([jsonData], DatabaseRecords.ferryTimings);
    } else {
      jsonData = cachedData[0] as Map<String, dynamic>;
    }

    List<TravelTiming> ferryTimings = [];
    List ferryData = jsonData['data'];
    print(ferryData);
    for (var element in ferryData) {
      ferryTimings.add(TravelTiming.fromJson(element));
      // print(TravelTiming.fromJson(element).toJson());
    }
    for (var j = 0; j < ferryTimings.length; j++) {
      for (int i = 0; i < ferryTimings[j].weekdays.toCampus.length; i++) {
        ferryTimings[j].weekdays.toCampus[i] =
            ferryTimings[j].weekdays.toCampus[i].toLocal();
        print(ferryTimings[j].weekdays.toCampus[i]);
      }
      for (int i = 0; i < ferryTimings[j].weekdays.fromCampus.length; i++) {
        ferryTimings[j].weekdays.fromCampus[i] =
            ferryTimings[j].weekdays.fromCampus[i].toLocal();
        print(ferryTimings[j].weekdays.fromCampus[i]);
      }
      for (int i = 0; i < ferryTimings[j].weekend.toCampus.length; i++) {
        ferryTimings[j].weekend.toCampus[i] =
            ferryTimings[j].weekend.toCampus[i].toLocal();
        print(ferryTimings[j].weekend.toCampus[i]);
      }
      for (int i = 0; i < ferryTimings[j].weekend.fromCampus.length; i++) {
        ferryTimings[j].weekend.fromCampus[i] =
            ferryTimings[j].weekend.fromCampus[i].toLocal();
        print(ferryTimings[j].weekend.fromCampus[i]);
      }
    }
    print(ferryTimings.length);
    return ferryTimings;
  }
}
