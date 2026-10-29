import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:onestop_dev/models/event_scheduler/admin_model.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/repository/events_api_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';

/// State for the events admin page: the clubs the user administers and the
/// events of the selected club.
class EventsAdminProvider extends ChangeNotifier {
  EventsAdminProvider({EventsAPIRepository? repository})
    : _repo = repository ?? EventsAPIRepository();

  final EventsAPIRepository _repo;

  List<Club> _userClubs = [];
  Club? _selectedClub;
  List<EventModel> _postedEvents = [];
  List<EventModel> _pastEvents = [];
  List<EventModel> _drafts = [];
  bool _isLoading = true;
  bool _isLoadingEvents = false;
  bool _isAdmin = false;

  List<Club> get userClubs => _userClubs;
  Club? get selectedClub => _selectedClub;

  /// Posted events that have not ended yet ("Your Events").
  List<EventModel> get postedEvents => _postedEvents;

  /// Posted events that have already ended.
  List<EventModel> get pastEvents => _pastEvents;
  List<EventModel> get drafts => _drafts;
  bool get isLoading => _isLoading;
  bool get isLoadingEvents => _isLoadingEvents;
  bool get isAdmin => _isAdmin;

  String get userEmail => LoginStore.userData['outlookEmail']?.toString() ?? '';

  Future<void> loadAdminData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final status = await _repo.checkSecy(email: userEmail);
      if (status != null) {
        _isAdmin = status.isAdmin;
        _userClubs = [if (status.club != null) status.club!];
        _selectedClub = _userClubs.isNotEmpty ? _userClubs.first : null;
        _isLoading = false;
        notifyListeners();
        await fetchEvents();
        return;
      }
    } catch (e) {
      log('Error loading admin data: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    if (_selectedClub == null) return;

    _isLoadingEvents = true;
    notifyListeners();

    try {
      final clubId = _selectedClub!.id;
      final results = await Future.wait([
        _repo.getAdminEvents(clubId: clubId),
        _repo.getAdminEvents(clubId: clubId, status: 'DRAFT'),
      ]);

      final now = DateTime.now();
      final posted =
          results[0].where((e) {
            final status = e.status.toUpperCase();
            return status == 'POSTED' || status == 'PUBLISHED';
          }).toList();
      _postedEvents = posted.where((e) => !e.endTime.isBefore(now)).toList();
      _pastEvents = posted.where((e) => e.endTime.isBefore(now)).toList();
      _drafts = results[1];
    } catch (e) {
      log('Error fetching events: $e');
      _postedEvents = [];
      _pastEvents = [];
      _drafts = [];
    }
    _isLoadingEvents = false;
    notifyListeners();
  }

  void selectClub(Club club) {
    if (club.name == _selectedClub?.name) return;
    _selectedClub = club;
    notifyListeners();
    fetchEvents();
  }

  /// Deletes [event] and refreshes the list. Returns `false` on failure.
  Future<bool> deleteEvent(EventModel event) async {
    try {
      await _repo.deleteEventById(event.id, email: userEmail);
      fetchEvents();
      return true;
    } catch (e) {
      log('Error deleting event: $e');
      return false;
    }
  }

  /// Saves an event as a draft or posts it.
  ///
  /// Uploads [bannerFile] first (when given) and stores the returned URL as
  /// `eventBanner`; otherwise [existingBannerUrl] is kept. Updates the event
  /// with [eventId] when set, creates a new one otherwise. Returns `false` on
  /// failure.
  Future<bool> submitEvent({
    required Map<String, dynamic> data,
    required bool asDraft,
    String? eventId,
    File? bannerFile,
    String? existingBannerUrl,
  }) async {
    log(
      '[submitEvent] Called — '
      'asDraft: $asDraft, '
      'eventId: $eventId, '
      'hasBannerFile: ${bannerFile != null}, '
      'existingBannerUrl: $existingBannerUrl',
    );
    log('[submitEvent] data: $data');

    final club = _selectedClub;
    if (club == null) {
      log('[submitEvent] No club selected — aborting');
      return false;
    }
    log('[submitEvent] Selected club: ${club.name} (id: ${club.id})');

    try {
      var bannerUrl = existingBannerUrl;
      if (bannerFile != null) {
        log('[submitEvent] Uploading banner image: ${bannerFile.path}');
        bannerUrl = await _repo.uploadEventImage(bannerFile);
        log('[submitEvent] Upload result — bannerUrl: $bannerUrl');
        if (bannerUrl == null) {
          log('[submitEvent] Banner upload failed — aborting');
          return false;
        }
      }

      final body = {
        ...data,
        'club_id': club.id,
        'status': asDraft ? 'DRAFT' : 'POSTED',
        if (bannerUrl != null) 'eventBanner': bannerUrl,
      };
      log('[submitEvent] Request body: $body');

      if (eventId != null && eventId.isNotEmpty) {
        log('[submitEvent] Updating existing event ($eventId) via putEvent');
        await _repo.putEvent(eventId, body, email: userEmail);
      } else {
        log('[submitEvent] Creating new event via postEvent');
        await _repo.postEvent(body, email: userEmail);
      }

      log('[submitEvent] Submit succeeded — refreshing events');
      fetchEvents();
      return true;
    } catch (e, stackTrace) {
      log('[submitEvent] Exception: $e');
      log('[submitEvent] Stack trace:\n$stackTrace');
      return false;
    }
  }
}
