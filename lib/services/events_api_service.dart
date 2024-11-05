import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
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
            // TODO: get this url from the run arguments in Endpoints class
            //  and use that here
            serverBaseUrl: Endpoints.eventsBaseUrl,
            onestopSecurityKey: Endpoints.apiSecurityKey);

  Future<Admin?> getAdmins() async {
    try {
      // TODO: Don't hardcode these paths
      //  Create static variables for each path in the endpoints class
      //  Name the variables appropriately!
      var response = await serverDio.get(Endpoints.getEventAdmin);

      var json = response.data;

      if (json != null && json is List) {
        final data = json[0];
        Admin admin = Admin.fromJson(data);
        return admin;
      } else {
        return null;
      }
    } catch (e) {
      Logger().e("Error fetching admins: $e");
      rethrow;
    }
  }

  // TODO: Don't Use FormData here
  //  The UI Layer should be independent of the Service Layer
  //  Use XFile/File and Map as function parameters
  Future<Map<String, dynamic>> postEvent(Map<String, dynamic> data) async {
    var res = await serverDio.post(serverBaseUrl, data: FormData.fromMap(data));
    return res.data;
  }

  Future<Map<String, dynamic>> deleteEvent(String id) async {
    var res = await serverDio.delete('${serverBaseUrl}/$id');
    return res.data;
  }

  // TODO: Same here
  Future<Map<String, dynamic>> putEvent(
      String id, Map<String, dynamic> data) async {
    try {
      // Make a PATCH request to the API with the updated event data
      var res = await serverDio.put(
        '${serverBaseUrl}/$id', // Replace with the actual endpoint
        data: FormData.fromMap(data),
      );
      return res.data; // Return the response data
    } catch (e) {
      // TODO: Api Service need not handle any exceptions
      //  No need to use Try Catch Blocks here
      //  The errors should be caught in the UI
      print("Error updating event: $e");
      throw Exception('Failed to update event: $e');
    }
  }

  Future<List<EventModel>> getEventPage(String category) async {
    try {
      var response = await serverDio.get(Endpoints.eventCategories);
      var json = response.data[category];

      if (json != null) {
        List<EventModel> eventPage =
            (json as List<dynamic>).map((e) => EventModel.fromJson(e)).toList();
        return eventPage;
      } else {
        return [];
      }
    } catch (e) {
      Logger().e("Error fetching events: $e");
      rethrow;
    }
  }
}
