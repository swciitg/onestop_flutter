import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static String restaurantURL = "https://onestop3.free.beeceptor.com/getAllOutlets";
  static Future<List<Map<String, dynamic>>>  getRestaurantData() async {
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
      return [];
    }
  }
}
