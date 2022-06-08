import 'dart:async';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/services/api.dart';

class DataProvider {
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
}
