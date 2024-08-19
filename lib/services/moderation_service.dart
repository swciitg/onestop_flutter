import 'package:dio/dio.dart';
import 'package:onestop_dev/globals/endpoints.dart';

class ModerationService {
  final _dio = Dio(BaseOptions(baseUrl: Endpoints.moderationBaseUrl));

  Future<bool> validateBuyOrSell(String text) async {
    final res = await _dio.post('/validateBuyOrSell', data: {'request': text});

    return res.data['valid'];
  }
}
