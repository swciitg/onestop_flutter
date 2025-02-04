import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/models/medicalcontacts/allmedicalcontacts.dart';
import 'package:onestop_dev/models/medicalcontacts/dropdown_contact_model.dart';
import 'package:onestop_dev/models/medicaltimetable/all_doctors.dart';
import 'package:onestop_dev/models/notifications/notification_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/repository/food_repository.dart';
import 'package:onestop_dev/repository/medical_repository.dart';
import 'package:onestop_dev/repository/notification_repository.dart';
import 'package:onestop_dev/repository/travel_repository.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../models/home/home_image.dart';

class DataService {
  static Future<Map<String, dynamic>?> getLastUpdated() async {
    var cachedData =
        await LocalStorage.instance.getListRecord(DatabaseRecords.lastUpdated);
    if (cachedData == null) {
      return null;
    }
    return cachedData[0] as Map<String, dynamic>;
  }

  static Future<List<TravelTiming>> getBusTiming() async {
    var cachedData =
        await LocalStorage.instance.getListRecord(DatabaseRecords.busTimings);
    Map<String, dynamic> jsonData;
    if (cachedData == null) {
      jsonData = await TravelRepository().getBusTiming();
      await LocalStorage.instance
          .storeListRecord([jsonData], DatabaseRecords.busTimings);
    } else {
      jsonData = cachedData[0] as Map<String, dynamic>;
    }
    List<dynamic> busData = jsonData['data'];
    List<TravelTiming> busTimings = [];
    for (var element in busData) {
      busTimings.add(TravelTiming.fromJson(element));
    }
    if (busTimings.isEmpty) {
      return busTimings;
    }
    for (int i = 0; i < busTimings[0].weekdays.toCampus.length; i++) {
      busTimings[0].weekdays.toCampus[i] =
          busTimings[0].weekdays.toCampus[i].toLocal();
    }
    for (int i = 0; i < busTimings[0].weekdays.fromCampus.length; i++) {
      busTimings[0].weekdays.fromCampus[i] =
          busTimings[0].weekdays.fromCampus[i].toLocal();
    }
    for (int i = 0; i < busTimings[0].weekend.toCampus.length; i++) {
      busTimings[0].weekend.toCampus[i] =
          busTimings[0].weekend.toCampus[i].toLocal();
    }
    for (int i = 0; i < busTimings[0].weekend.fromCampus.length; i++) {
      busTimings[0].weekend.fromCampus[i] =
          busTimings[0].weekend.fromCampus[i].toLocal();
    }
    return busTimings;
  }

  static Future<List<RestaurantModel>> getRestaurants() async {
    var cachedData =
        await LocalStorage.instance.getListRecord(DatabaseRecords.restaurant);

    if (cachedData == null) {
      List<Map<String, dynamic>> restaurantData =
          await FoodRepository().getRestaurantData();
      List<RestaurantModel> restaurants =
          restaurantData.map((e) => RestaurantModel.fromJson(e)).toList();

      await LocalStorage.instance
          .storeListRecord(restaurantData, DatabaseRecords.restaurant);

      return restaurants;
    }
    return cachedData
        .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<RegisteredCourses> getTimeTable({required String roll}) async {
    var cachedData = (await LocalStorage.instance
        .getListRecord(DatabaseRecords.timetable))?[0];
    if (cachedData == null) {
      RegisteredCourses timetableData =
          await APIRepository().getTimeTable(roll: roll);
      await LocalStorage.instance
          .storeListRecord([timetableData.toJson()], DatabaseRecords.timetable);
      return timetableData;
    }
    return RegisteredCourses.fromJson(cachedData as Map<String, dynamic>);
  }

  static Future<List<HomeImageModel>> getHomeImageLinks() async {
    Map<String, dynamic>? cachedData =
        await LocalStorage.instance.getJsonRecord(DatabaseRecords.homePage);
    List<HomeImageModel> res = [];
    List<Map<String, dynamic>> imageLinks;
    if (cachedData == null) {
      final homePageUrls = await APIRepository().getHomePageUrls();
      imageLinks =
          (homePageUrls['cardsDataList'] as List).cast<Map<String, dynamic>>();
      await LocalStorage.instance
          .storeJsonRecord(homePageUrls, DatabaseRecords.homePage);
    } else {
      imageLinks =
          (cachedData['cardsDataList'] as List).cast<Map<String, dynamic>>();
    }

    for (Map<String, dynamic> link in imageLinks) {
      res.add(HomeImageModel.fromJson(link));
    }
    return res;
  }

  static Future<List<HomeTabTile>> getQuickLinks() async {
    var cachedData =
        (await LocalStorage.instance.getJsonRecord(DatabaseRecords.homePage));
    List<HomeTabTile> res = [];
    var quickLinks;
    if (cachedData == null) {
      try {
        var homePageUrls = await APIRepository().getHomePageUrls();
        quickLinks = homePageUrls['quickLinks'];
        await LocalStorage.instance
            .storeJsonRecord(homePageUrls, DatabaseRecords.homePage);
      } catch (e) {
        print(e.toString());
      }
    } else {
      quickLinks = cachedData['quickLinks'] as List<dynamic>;
    }
    for (var link in quickLinks) {
      if (link['name'] == "election_id") {
        // res.add(const HomeTabTile(
        //   label: "Election Register",
        //   icon: FluentIcons.person_arrow_right_16_regular,
        //   routeId: ElectionLoginWebView.id,
        //   newBadge: true,
        // ));
      } else {
        res.add(HomeTabTile(
          label: link['name'],
          iconCode: link['icon'],
          link: link['link'],
        ));
      }
    }
    return res;
  }

  static Future<MealType> getMealData({
    required Mess mess,
    required String day,
    required String mealType,
  }) async {
    var cachedData = (await LocalStorage.instance
        .getListRecord(DatabaseRecords.messMenu))?[0];
    Map<String, dynamic>? jsonData;

    if (cachedData == null) {
      jsonData = await FoodRepository().getMealData();
      LocalStorage.instance
          .storeListRecord([jsonData], DatabaseRecords.messMenu);
    } else {
      jsonData = cachedData as Map<String, dynamic>;
    }

    List<dynamic> answer = jsonData['details']!;
    var meal = answer.firstWhere((m) => m['hostel'] == mess.databaseString,
        orElse: () => 'no data');
    if (meal == 'no data') {
      return MealType(
          id: '',
          mealDescription: "Not updated by ${mess.displayString}'s HMC. "
              "Kindly Contact ask them to update",
          startTiming: DateTime.now().toLocal(),
          endTiming: DateTime.now().toLocal());
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
        await LocalStorage.instance.getListRecord(DatabaseRecords.contacts);
    SplayTreeMap<String, ContactModel> people = SplayTreeMap();
    if (cachedData == null) {
      List<Map<String, dynamic>> contactData =
          await APIRepository().getContactData();
      for (var element in contactData) {
        people[element['sectionName']] = ContactModel.fromJson(element);
      }
      await LocalStorage.instance
          .storeListRecord(contactData, DatabaseRecords.contacts);
      return people;
    } else {
      for (var element in cachedData) {
        var x = element as Map<String, dynamic>;
        people[x['sectionName']] = ContactModel.fromJson(x);
      }
      return people;
    }
  }

  static Future<AllDoctors> getMedicalTimeTable() async {
    try {
      return await MedicalRepository().getmedicalTimeTable();
    } catch (e) {
      debugPrint("Error Fetching Medical TT");
      rethrow;
    }
  }

  static Future<Allmedicalcontacts?> getMedicalContacts() async {
    Allmedicalcontacts medicalContactData = Allmedicalcontacts(alldoctors: []);
    try {
      Allmedicalcontacts? medicalContactData =
          await MedicalRepository().getMedicalContactData();
      return medicalContactData;
    } catch (e) {
      print(e);
    }
    return medicalContactData;
  }

  static Future<List<DropdownContactModel>> getDropDownContacts() async {
    List<DropdownContactModel> DropDownContacts = [];
    var cachedData = await LocalStorage.instance
        .getListRecord(DatabaseRecords.dropdowncontacts);
    try {
      List<Map<String, dynamic>> DropDownData =
          await APIRepository().getDropDownContacts();
      await LocalStorage.instance
          .storeListRecord(DropDownData, DatabaseRecords.medicalcontacts);
      for (var element in DropDownData) {
        DropdownContactModel doctor = DropdownContactModel.fromJson(element);
        DropDownContacts.add(doctor);
      }
    } catch (e) {
      print(e);
      if (cachedData == null) {
        return DropDownContacts;
      } else {
        for (var element in cachedData) {
          DropdownContactModel doctor =
              DropdownContactModel.fromJson(element as Map<String, dynamic>);
          DropDownContacts.add(doctor);
        }
      }
    }
    return DropDownContacts;
  }

  static Future<Map<String, List<NotifsModel>>> getNotifications() async {
    var response = await NotificationRepository().getNotifications();
    Map<String, List<NotifsModel>> output = {
      "userPersonalNotifs": [],
      "allTopicNotifs": []
    };

    for (var notif in response[0].data["allTopicNotifs"]!) {
      output["allTopicNotifs"]!.add(NotifsModel.fromJson(notif));
    }
    for (var notif in response[1].data["userPersonalNotifs"]!) {
      output["userPersonalNotifs"]!.add(NotifsModel.fromJson(notif));
    }
    return output;
  }

  static Future<List<TravelTiming>> getFerryTiming() async {
    var cachedData =
        await LocalStorage.instance.getListRecord(DatabaseRecords.ferryTimings);
    Map<String, dynamic> jsonData;
    if (cachedData == null) {
      jsonData = await TravelRepository().getFerryTiming();
      await LocalStorage.instance
          .storeListRecord([jsonData], DatabaseRecords.ferryTimings);
    } else {
      jsonData = cachedData[0] as Map<String, dynamic>;
    }

    List<TravelTiming> ferryTimings = [];
    List ferryData = jsonData['data'];
    for (var element in ferryData) {
      ferryTimings.add(TravelTiming.fromJson(element));
    }
    for (var j = 0; j < ferryTimings.length; j++) {
      for (int i = 0; i < ferryTimings[j].weekdays.toCampus.length; i++) {
        ferryTimings[j].weekdays.toCampus[i] =
            ferryTimings[j].weekdays.toCampus[i].toLocal();
      }
      for (int i = 0; i < ferryTimings[j].weekdays.fromCampus.length; i++) {
        ferryTimings[j].weekdays.fromCampus[i] =
            ferryTimings[j].weekdays.fromCampus[i].toLocal();
      }
      for (int i = 0; i < ferryTimings[j].weekend.toCampus.length; i++) {
        ferryTimings[j].weekend.toCampus[i] =
            ferryTimings[j].weekend.toCampus[i].toLocal();
      }
      for (int i = 0; i < ferryTimings[j].weekend.fromCampus.length; i++) {
        ferryTimings[j].weekend.fromCampus[i] =
            ferryTimings[j].weekend.fromCampus[i].toLocal();
      }
    }
    return ferryTimings;
  }
}
