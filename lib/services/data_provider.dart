import 'dart:async';
import 'dart:collection';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';

class DataProvider
{
  static Future<List<RestaurantModel>> getRestaurants() async {
    var cachedData = await LocalStorage.instance.getRecord("Restaurant");
    if (cachedData == null) {
      print("Restaurant Data not in Cache. Using API...");
      List<Map<String,dynamic>> restaurantData = await APIService.getRestaurantData();
      List<RestaurantModel> restaurants = restaurantData.map((e) => RestaurantModel.fromJson(e)).toList();
      await LocalStorage.instance.storeData(restaurantData, "Restaurant");
      return restaurants;
    }
    print("Restaurant Data Exists in Cache");
    return cachedData.map((e) => RestaurantModel.fromJson(e as Map<String,dynamic>)).toList();
  }

  static Future<SplayTreeMap<String, ContactModel>> getContacts() async {
    var cachedData = await LocalStorage.instance.getRecord("Contact");
    SplayTreeMap<String, ContactModel> people= SplayTreeMap();

    if (cachedData == null) {
      print("Contact Data not in Cache. Using API...");
      List<Map<String,dynamic>> contactData = await APIService.getContactData();
      contactData.forEach((element) => people[element['name']] = ContactModel.fromJson(element));
      await LocalStorage.instance.storeData(contactData, "Contact");
      return people;
    }
    print("Contact Data Exists in Cache");
    cachedData.forEach((element)
    {
      var x = element as Map<String, dynamic>;
      people[x['name']] = ContactModel.fromJson(x);
    });
    return people;
  }


}
