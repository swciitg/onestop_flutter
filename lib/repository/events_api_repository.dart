import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/event_scheduler/admin_model.dart';
import 'package:onestop_dev/models/event_scheduler/club_model.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/models/event_scheduler/student_event_interaction_model.dart';
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

  Future<Map<String, dynamic>> createClub(ClubModel club) async {
    final response = await serverDio.post(
      '/api/v1/clubs/create-club',
      data: club.toJson(),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<List<ClubModel>> getAllClubs({String? category, String? search}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (category != null && category.isNotEmpty && category != 'All') {
        queryParameters['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final response = await serverDio.get(
        '/api/v1/clubs/get-all',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );
      final json = response.data;
      if (json['success'] == true && json['data'] is List) {
        return (json['data'] as List<dynamic>)
            .map((e) => ClubModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error fetching clubs: $e');
      return [];
    }
  }

  Future<ClubModel?> getClubDetails(String clubId) async {
    try {
      final response = await serverDio.get('/api/v1/clubs/$clubId');
      final json = response.data;
      if (json['success'] == true && json['data'] is Map) {
        return ClubModel.fromJson(json['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error fetching club details: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> createEvent(
    EventModel event, {
    required String email,
  }) async {
    final response = await serverDio.post(
      '/api/v1/events/create-event',
      data: event.toJson(),
      options: Options(headers: {'x-email': email}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> postEvent(
    Map<String, dynamic> data, {
    String? email,
  }) async {
    final userEmail = email ?? LoginStore.userData['outlookEmail'] ?? '';
    final response = await serverDio.post(
      '/api/v1/events/create-event',
      data: data,
      options: Options(headers: {'x-email': userEmail}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> updateEvent(
    String eventId,
    EventModel event, {
    required String email,
  }) async {
    final response = await serverDio.put(
      '/api/v1/events/update-event/$eventId',
      data: event.toJson(),
      options: Options(headers: {'x-email': email}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> putEvent(
    String eventId,
    Map<String, dynamic> data, {
    String? email,
  }) async {
    final userEmail = email ?? LoginStore.userData['outlookEmail'] ?? '';
    final response = await serverDio.put(
      '/api/v1/events/update-event/$eventId',
      data: data,
      options: Options(headers: {'x-email': userEmail}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> deleteEventById(
    String eventId, {
    required String email,
  }) async {
    final response = await serverDio.delete(
      '/api/v1/events/delete-event/$eventId',
      options: Options(headers: {'x-email': email}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> deleteEvent(String eventId) async {
    final userEmail = LoginStore.userData['outlookEmail'] ?? '';
    return deleteEventById(eventId, email: userEmail);
  }

  Future<List<EventModel>> getAdminEvents({
    required String clubId,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'club_id': clubId};
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }
      final response = await serverDio.get(
        '/api/v1/events/get-events',
        queryParameters: queryParameters,
      );
      final json = response.data;
      if (json['success'] == true && json['data'] is List) {
        return (json['data'] as List<dynamic>)
            .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error getting admin events: $e');
      return [];
    }
  }

  Future<List<EventModel>> getAllEvents({
    String? feedType,
    String? search,
    String? date,
    String? tags,
    int? limit,
    int? page,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (feedType != null && feedType.isNotEmpty) {
        queryParameters['feedType'] = feedType;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (date != null && date.isNotEmpty) {
        queryParameters['date'] = date;
      }
      if (tags != null && tags.isNotEmpty && tags != 'All') {
        queryParameters['tags'] = tags;
      }
      if (limit != null) {
        queryParameters['limit'] = limit.toString();
      }
      if (page != null) {
        queryParameters['page'] = page.toString();
      }

      final response = await serverDio.get(
        '/api/v1/event-discovery',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );
      final json = response.data;
      if (json['success'] == true && json['data'] is List) {
        return (json['data'] as List<dynamic>)
            .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error fetching all events: $e');
      return [];
    }
  }

  /// Helper for pagination controllers in feed tabs
  Future<List<EventModel>> getEventPage(
    String category, {
    int page = 1,
    int limit = 10,
  }) async {
    if (category == 'Saved') {
      final rollNo = LoginStore.userData['rollNo'] ?? '';
      final email = LoginStore.userData['outlookEmail'] ?? '';
      if (rollNo.isNotEmpty || email.isNotEmpty) {
        return getUserLikedEvents(rollNo: rollNo, email: email);
      }
      return [];
    }

    final tags = (category == 'All' || category == 'Your Events') ? null : category;
    return getAllEvents(
      tags: tags,
      page: page,
      limit: limit,
    );
  }

  Future<EventModel?> getEventDetails(String eventId, {String? studentId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (studentId != null && studentId.isNotEmpty) {
        queryParams['student_id'] = studentId;
      }
      final response = await serverDio.get(
        '/api/v1/event-discovery/get-event-details/$eventId',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final json = response.data;
      if (json['success'] == true && json['data'] is Map) {
        return EventModel.fromJson(json['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error getting event details: $e');
      return null;
    }
  }

  Future<List<EventModel>> getUserLikedEvents({
    required String rollNo,
    required String email,
  }) async {
    try {
      final response = await serverDio.get(
        '/api/v1/event-discovery/liked',
        queryParameters: {
          'rollNo': rollNo,
          'email': email,
        },
      );
      final json = response.data;
      if (json['success'] == true && json['data'] is List) {
        return (json['data'] as List<dynamic>)
            .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error getting user liked events: $e');
      return [];
    }
  }

  Future<StudentEventInteractionModel?> toggleLikeEvent({
    required String rollNo,
    required String email,
    required String eventId,
    required bool like,
  }) async {
    try {
      final response = await serverDio.post(
        '/api/v1/students/like-event',
        queryParameters: {
          'rollNo': rollNo,
          'email': email,
          'event_id': eventId,
        },
        data: {'like': like},
      );
      final json = response.data;
      if (json['interaction'] != null && json['interaction'] is Map) {
        return StudentEventInteractionModel.fromJson(
            json['interaction'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error toggling like event: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> submitFeedback({
    required String rollNo,
    required String email,
    required String eventId,
    required EventFeedback feedback,
  }) async {
    final response = await serverDio.post(
      '/api/v1/students/submit-feedback',
      queryParameters: {
        'rollNo': rollNo,
        'email': email,
        'event_id': eventId,
      },
      data: feedback.toJson(),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<List<StudentEventInteractionModel>> getEventFeedback(String eventId) async {
    try {
      final response = await serverDio.get(
        '/api/v1/students/get-feedback',
        queryParameters: {'event_id': eventId},
      );
      final json = response.data;
      if (json['success'] == true && json['data'] is List) {
        return (json['data'] as List<dynamic>)
            .map((e) => StudentEventInteractionModel.fromJson(
                e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error getting event feedback: $e');
      return [];
    }
  }

  /// Admin lookup: checks admin status and returns clubs for the user
  Future<Admin?> getAdmins() async {
    try {
      final response = await serverDio.get('/api/v1/admin/me');
      if (response.data is Map<String, dynamic>) {
        return Admin.fromJson(Map<String, dynamic>.from(response.data));
      }
    } catch (_) {
      // Backend /api/v1/admin/me route not yet deployed on server (see backend_requirements.md)
    }

    // Default admin structure fallback matching boards and clubs
    final email = LoginStore.userData['outlookEmail']?.toString() ?? '';
    return Admin(clubs: [
      Club(
        name: "Technical Board",
        members: ClubMembers(
          admins: [if (email.isNotEmpty) email],
          clubsOrgs: ["Coding Club", "Robotics Club", "Aeromodelling Club", "Electronics Club"],
        ),
      ),
      Club(
        name: "Cultural Board",
        members: ClubMembers(
          admins: [if (email.isNotEmpty) email],
          clubsOrgs: ["Octaves", "Cadence", "Anchorenza", "Expressions"],
        ),
      ),
      Club(
        name: "Sports Board",
        members: ClubMembers(
          admins: [if (email.isNotEmpty) email],
          clubsOrgs: ["Football", "Cricket", "Badminton", "Basketball", "Athletics"],
        ),
      ),
      Club(
        name: "Students' Web Committee",
        members: ClubMembers(
          admins: [if (email.isNotEmpty) email],
          clubsOrgs: ["SWC"],
        ),
      ),
    ]);
  }
}
