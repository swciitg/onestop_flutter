import 'package:dio/dio.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/event_scheduler/admin_model.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_kit/onestop_kit.dart';

class EventsApiService extends OneStopApi {
  EventsApiService()
      // THE SUPER CONSTRUCTOR HANDLES THE API INTERCEPTORS TO ADD THE
      // APPROPRIATE AUTHENTICATION HEADERS AND SECURITY KEY FOR EVERY REQUEST
      // MADE USING 'serverDio' OBJECT
      : super(
            onestopBaseUrl: Endpoints.baseUrl,
            serverBaseUrl: Endpoints.eventsBaseUrl,
            onestopSecurityKey: Endpoints.apiSecurityKey);

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
    // Make a PATCH request to the API with the updated event data
    var res = await serverDio.put(
      '/$id', // Replace with the actual endpoint
      data: FormData.fromMap(data),
    );
    return res.data; // Return the response data
  }

  Future<List<EventModel>> getEventPage(String category) async {
    var response = await serverDio.get(Endpoints.eventCategories);
    var json = response.data[category];

    if (json != null) {
      List<EventModel> eventPage =
          (json as List<dynamic>).map((e) => EventModel.fromJson(e)).toList();
      return eventPage;
    } else {
      return [];
    }
  }
}
