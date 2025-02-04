import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_kit/onestop_kit.dart';

class FoodRepository extends OneStopApi {
  FoodRepository()
      : super(
          onestopBaseUrl: Endpoints.baseUrl,
          serverBaseUrl: Endpoints.baseUrl,
          onestopSecurityKey: Endpoints.apiSecurityKey,
        );

  Future<Map<String, dynamic>> getMealData() async {
    try {
      final res = await serverDio.get(Endpoints.messURL);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getRestaurantData() async {
    var response = await serverDio.get(Endpoints.restaurantURL);
    var status = response.statusCode;
    var body = response.data;
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

  Future<List<Map<String, dynamic>>> getMessMenu() async {
    var response = await serverDio.get(Endpoints.messURL);
    var status = response.statusCode;
    var body = response.data;
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
}
