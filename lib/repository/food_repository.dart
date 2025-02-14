import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/repository/api_repository.dart';

class FoodRepository extends APIRepository {
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
