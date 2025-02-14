import 'package:dio/dio.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/repository/api_repository.dart';

class UserRepository extends APIRepository {
  Future<Response> guestUserLogin() async {
    var response = await serverDio.post(Endpoints.guestLogin);
    return response;
  }

  Future<Map> getUserProfile() async {
    try {
      final response = await serverDio.get(Endpoints.userProfile);
      return response.data;
    } catch (e) {
      throw DioException(
          requestOptions: RequestOptions(path: Endpoints.userProfile),
          response: (e as DioException).response);
    }
  }

  Future<void> updateUserProfile(Map data, String? deviceToken) async {
    Map<String, dynamic> queryParameters = {};
    if (deviceToken != null) queryParameters["deviceToken"] = deviceToken;
    await serverDio.patch(Endpoints.userProfile,
        data: data, queryParameters: queryParameters);
  }
}
