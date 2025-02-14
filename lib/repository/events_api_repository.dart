import 'package:dio/dio.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/event_scheduler/admin_model.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';

class EventsAPIRepository extends OneStopApi {
  EventsAPIRepository()
      : super(
          onestopBaseUrl: Endpoints.baseUrl,
          serverBaseUrl: Endpoints.eventsBaseUrl,
          onestopSecurityKey: Endpoints.apiSecurityKey,
          onRefreshTokenExpired: () async {
            await LoginStore().clearAppData();
            showSnackBar("Your session has expired!! Login again.");
          },
        );

  Future<Admin?> getAdmins() async {
    var response = await serverDio.get(Endpoints.getEventAdmin);
    var json = response.data;

    if (json != null && json is List) {
      final data = json[0];
      Admin admin = Admin.fromJson(data);
      return admin;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> postEvent(Map<String, dynamic> data) async {
    var res = await serverDio.post(serverBaseUrl, data: FormData.fromMap(data));
    return res.data;
  }

  Future<Map<String, dynamic>> deleteEvent(String id) async {
    var res = await serverDio.delete('/$id');
    return res.data;
  }

  Future<Map<String, dynamic>> putEvent(
      String id, Map<String, dynamic> data) async {
    var res = await serverDio.put('/$id', data: FormData.fromMap(data));
    return res.data;
  }

  Future<List<EventModel>> getEventPage(String category) async {
    var response = await serverDio.get(Endpoints.eventCategories);
    var json = response.data[category];

    if (json != null) {
      List<EventModel> eventPage = (json as List<dynamic>).map((e) {
        return EventModel.fromJson(e);
      }).toList();
      return eventPage;
    } else {
      return [];
    }
  }
}
