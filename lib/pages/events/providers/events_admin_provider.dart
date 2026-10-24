import 'dart:developer';

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
  int _selectedTabIndex = 0; // 0 = Past Events, 1 = Drafts
  List<EventModel> _events = [];
  bool _isLoading = true;
  bool _isLoadingEvents = false;
  bool _isAdmin = false;

  List<Club> get userClubs => _userClubs;
  Club? get selectedClub => _selectedClub;
  int get selectedTabIndex => _selectedTabIndex;
  List<EventModel> get events => _events;
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
      final status = _selectedTabIndex == 1 ? 'DRAFT' : null;
      final events = await _repo.getAdminEvents(
        clubId: _selectedClub!.id ?? _selectedClub!.name,
        status: status,
      );

      if (_selectedTabIndex == 0) {
        // Past Events: posted events with end time before now
        _events =
            events.where((e) {
              final isPast = e.endTime.isBefore(DateTime.now());
              final isPosted =
                  e.status.toUpperCase() == 'POSTED' ||
                  e.status.toUpperCase() == 'PUBLISHED';
              return status == null ? isPast : isPosted;
            }).toList();
      } else {
        _events = events;
      }
    } catch (e) {
      log('Error fetching events: $e');
      _events = [];
    }
    _isLoadingEvents = false;
    notifyListeners();
  }

  void selectTab(int index) {
    if (index == _selectedTabIndex) return;
    _selectedTabIndex = index;
    notifyListeners();
    fetchEvents();
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
}
