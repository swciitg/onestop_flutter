import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';

class IrbsApiRepository extends OneStopApi {
  IrbsApiRepository()
      : super(
          onestopBaseUrl: Endpoints.baseUrl,
          serverBaseUrl: Endpoints.irbsBaseUrl,
          onestopSecurityKey: Endpoints.apiSecurityKey,
          onRefreshTokenExpired: () async {
            await LoginStore().clearAppData();
            showSnackBar("Your session has expired!! Login again.");
          },
        );

  Future<Map<String, dynamic>> postMessOpi(Map<String, dynamic> data) async {
    try {
      final json = jsonEncode(data);
      final res = await onestopDio.post(
        Endpoints.irbsBaseUrl + Endpoints.messOpi,
        data: json,
      );
      return res.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postMessSubChange(
      Map<String, dynamic> data) async {
    final json = jsonEncode(data);
    try {
      final res = await onestopDio.post(
        Endpoints.irbsBaseUrl + Endpoints.messSubChange,
        data: json,
      );
      return res.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
