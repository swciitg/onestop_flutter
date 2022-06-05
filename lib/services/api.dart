import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantService {
  final String url = "https://onestop2.free.beeceptor.com/getAllOutlets";
  Future<List<Map<String, dynamic>>> getData() async {
    http.Response response = await http.get(Uri.parse(url));
    var status = response.statusCode;
    var body = jsonDecode(response.body);
    if (status == 200) {
      List<Map<String, dynamic>> data = [];
      for (var json in body) {
        data.add(json);
      }
      return data;
    } else {
      print(status);
      return [];
    }
  }
}
