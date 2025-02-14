import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/repository/api_repository.dart';

class TravelRepository extends APIRepository {
  Future<Map<String, dynamic>> getBusTiming() async {
    try {
      final res = await serverDio.get(Endpoints.busStops);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFerryTiming() async {
    try {
      final res = await serverDio.get(Endpoints.ferryURL);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getFerryData() async {
    var response = await serverDio.get(Endpoints.ferryURL);
    var status = response.statusCode;
    var json = response.data;
    if (status == 200) {
      List<Map<String, dynamic>> answer = [];
      for (var temp in json) {
        answer.add(temp);
      }
      return answer;
    } else {
      throw Exception("Ferry Data could not be fetched");
    }
  }
}
