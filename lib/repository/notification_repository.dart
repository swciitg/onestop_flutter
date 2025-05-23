import 'package:dio/dio.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/repository/api_repository.dart';

class NotificationRepository extends APIRepository {
  Future<List<Response>> getNotifications() async {
    final results = await Future.wait([
      serverDio.get(Endpoints.generalNotifications),
      serverDio.get(Endpoints.userNotifications)
    ]);
    return results;
  }

  Future<void> deletePersonalNotifications() async {
    await serverDio.delete(Endpoints.userNotifications);
  }

  Future<void> postFCMToken(String fcmToken) async {
    await serverDio.post(Endpoints.userDeviceTokens, data: {
      "deviceToken": fcmToken,
    });
  }

  Future<void> updateFCMToken(Map data) async {
    await serverDio.patch(Endpoints.userDeviceTokens, data: data);
  }

  Future<void> updateNotificationPreferences(Map data) async {
    await serverDio.patch(Endpoints.userNotifPrefs, data: data);
  }
}
