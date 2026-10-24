import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/models/event_scheduler/student_event_interaction_model.dart';
import 'package:onestop_dev/repository/events_api_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';

/// Single source of truth for the student-facing Events screens (home, saved,
/// attended and the event popup), so that going/saved state stays in sync
/// across all of them.
class EventsProvider extends ChangeNotifier {
  EventsProvider({EventsAPIRepository? repository})
    : _repo = repository ?? EventsAPIRepository();

  final EventsAPIRepository _repo;

  // ---------------------------------------------------------------------------
  // Home feeds
  // ---------------------------------------------------------------------------
  List<EventModel> _todayEvents = [];
  List<EventModel> _trendingEvents = [];
  List<EventModel> _exploreEvents = [];
  List<EventModel> _likedEvents = [];
  List<EventModel> _allIndexedEvents = [];

  final Set<String> _initialLikedEventIds = {};
  final Set<String> _initialGoingEventIds = {};

  bool _isHomeLoading = true;
  bool _hasHomeError = false;

  List<EventModel> get todayEvents => _todayEvents;
  List<EventModel> get trendingEvents => _trendingEvents;
  List<EventModel> get exploreEvents => _exploreEvents;
  List<EventModel> get likedEvents => _likedEvents;
  bool get isHomeLoading => _isHomeLoading;
  bool get hasHomeError => _hasHomeError;
  bool get hasIndexedEvents => _allIndexedEvents.isNotEmpty;
  int get allEventsCount =>
      _exploreEvents.length + _todayEvents.length + _trendingEvents.length;

  // ---------------------------------------------------------------------------
  // Admin
  // ---------------------------------------------------------------------------
  bool _isAdmin = false;

  /// Whether the current user is a club secretary (shows the Manage tab).
  bool get isAdmin => _isAdmin;

  Future<void> loadAdminStatus() async {
    final status = await _repo.checkSecy(email: _email);
    if (status == null || status.isAdmin == _isAdmin) return;
    _isAdmin = status.isAdmin;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // All events (paginated)
  // ---------------------------------------------------------------------------
  static const int _allEventsPageSize = 10;

  final List<EventModel> _allEvents = [];
  int _allEventsPage = 0;
  bool _isAllEventsLoading = false;
  bool _isAllEventsLoadingMore = false;
  bool _hasMoreAllEvents = true;
  bool _hasAllEventsError = false;
  int _allEventsRequestId = 0; // drops responses from superseded requests

  // Filters for the All Events screen. Search, date and tag are applied by the
  // backend; organiser narrows the loaded pages locally.
  String _allSearch = '';
  DateTime? _allDate;
  String? _allTag;
  String? _allOrganiser;

  String get allSearch => _allSearch;
  DateTime? get allDate => _allDate;
  String? get allTag => _allTag;
  String? get allOrganiser => _allOrganiser;

  /// All loaded events, narrowed by the organiser filter.
  List<EventModel> get allEvents =>
      _allOrganiser == null
          ? _allEvents
          : _allEvents.where((e) => e.clubOrg == _allOrganiser).toList();

  /// Tags offered by the tag filter. Fixed (matches the Figma domain list) so
  /// every tag is selectable regardless of which events are loaded.
  static const List<String> allEventTagOptions = [
    'Finance',
    'Cultural',
    'Coding',
    'Business',
    'Sports',
    'Welfare',
    'Design',
  ];

  /// Organisers seen across the loaded events, for the organiser picker.
  List<String> get allEventOrganiserOptions =>
      {
          for (final e in _allEvents) e.clubOrg,
        }.where((o) => o.isNotEmpty).toList()
        ..sort();

  bool get isAllEventsLoading => _isAllEventsLoading;
  bool get hasAllEventsFilters =>
      _allSearch.isNotEmpty ||
      _allDate != null ||
      _allTag != null ||
      _allOrganiser != null;
  bool get isAllEventsLoadingMore => _isAllEventsLoadingMore;
  bool get hasMoreAllEvents => _hasMoreAllEvents;
  bool get hasAllEventsError => _hasAllEventsError;

  // ---------------------------------------------------------------------------
  // Saved / attended
  // ---------------------------------------------------------------------------
  bool _isLikedLoading = true;
  final Map<String, String> _feedbackByEventId = {};

  bool get isLikedLoading => _isLikedLoading;

  /// Saved events that haven't ended yet and start today (or already started).
  List<EventModel> get savedTodayEvents {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day + 1);
    return _likedEvents
        .where(
          (e) =>
              e.endDateTime.isAfter(now) &&
              e.startDateTime.isBefore(endOfToday),
        )
        .toList();
  }

  /// Saved events that haven't ended yet and start after today.
  List<EventModel> get savedLaterEvents {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day + 1);
    return _likedEvents
        .where(
          (e) =>
              e.endDateTime.isAfter(now) &&
              !e.startDateTime.isBefore(endOfToday),
        )
        .toList();
  }

  /// Saved events whose end time has passed, most recently ended first.
  List<EventModel> get attendedEvents {
    final now = DateTime.now();
    return _likedEvents.where((e) => e.endDateTime.isBefore(now)).toList()
      ..sort((a, b) => b.endDateTime.compareTo(a.endDateTime));
  }

  String? feedbackFor(String eventId) => _feedbackByEventId[eventId];

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------
  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  Timer? _debounceTimer;
  Fuzzy<EventModel>? _fuzzyEngine;
  String _searchQuery = '';
  List<EventModel> _searchResults = [];
  bool _isSearching = false;

  String get searchQuery => _searchQuery;
  List<EventModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  // ---------------------------------------------------------------------------
  // User identity
  // ---------------------------------------------------------------------------
  String get _rollNo => LoginStore.userData['rollNo']?.toString() ?? '';
  String get _email => LoginStore.userData['outlookEmail']?.toString() ?? '';

  /// Identity sent when toggling a like; falls back to a guest identity.
  String get _likeRollNo =>
      LoginStore.userData['rollNo']?.toString() ??
      LoginStore.userData['rollno']?.toString() ??
      LoginStore.userData['rollNumber']?.toString() ??
      'guest';
  String get _likeEmail =>
      LoginStore.userData['outlookEmail']?.toString() ??
      LoginStore.userData['email']?.toString() ??
      'guest@iitg.ac.in';

  bool get _hasIdentity => _rollNo.isNotEmpty || _email.isNotEmpty;

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------
  Future<void> loadHome() async {
    _isHomeLoading = true;
    _hasHomeError = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repo.getAllEvents(feedType: 'TODAY'),
        _repo.getAllEvents(feedType: 'TRENDING'),
        _repo.getAllEvents(limit: 10),
        if (_hasIdentity)
          _repo.getUserLikedEvents(rollNo: _rollNo, email: _email)
        else
          Future.value(<EventModel>[]),
      ]);

      _todayEvents = results[0];
      _trendingEvents = results[1];
      _exploreEvents = results[2];
      _likedEvents = results[3];
      _isLikedLoading = false;
      _isHomeLoading = false;
      _hasHomeError = false;

      // Snapshot initial liked & going IDs to avoid double counting baseline
      _initialLikedEventIds
        ..clear()
        ..addAll(_likedEvents.map((e) => e.id));
      _initialGoingEventIds.clear();

      // Index all events for fast multi-field fuzzy search with a unique key
      final Map<String, EventModel> uniqueEvents = {};
      for (final list in [
        _todayEvents,
        _trendingEvents,
        _exploreEvents,
        _likedEvents,
      ]) {
        for (final e in list) {
          final key =
              e.id.isNotEmpty
                  ? e.id
                  : '${e.clubId}_${e.name}_${e.startDateTime.millisecondsSinceEpoch}';
          uniqueEvents[key] = e;
          if (e.userStatus?.isInterested == true) {
            _initialLikedEventIds.add(e.id);
          }
          if (e.userStatus?.isRegistered == true) {
            _initialGoingEventIds.add(e.id);
          }
        }
      }
      _allIndexedEvents = uniqueEvents.values.toList();
      _rebuildFuzzyIndex();
    } catch (e) {
      log('Error loading home data: $e');
      _isHomeLoading = false;
      _hasHomeError = _allIndexedEvents.isEmpty;
    }
    notifyListeners();
  }

  String? get _allDateParam =>
      _allDate == null ? null : DateFormat('yyyy-MM-dd').format(_allDate!);

  /// Updates the All Events filters and reloads from the first page.
  /// Pass `clearDate` / `clearTag` / `clearOrganiser` to remove a filter.
  Future<void> setAllEventsFilters({
    String? search,
    DateTime? date,
    String? tag,
    String? organiser,
    bool clearDate = false,
    bool clearTag = false,
    bool clearOrganiser = false,
  }) {
    if (search != null) _allSearch = search.trim();
    if (clearDate) _allDate = null;
    if (date != null) _allDate = date;
    if (clearTag) _allTag = null;
    if (tag != null) _allTag = tag;
    if (clearOrganiser) _allOrganiser = null;
    if (organiser != null) _allOrganiser = organiser;
    // Organiser is a local filter; no refetch needed.
    if (search == null &&
        date == null &&
        tag == null &&
        !clearDate &&
        !clearTag) {
      notifyListeners();
      return Future.value();
    }
    return loadAllEvents(force: true);
  }

  /// Resets and loads the first page of all events.
  Future<void> loadAllEvents({bool force = false}) async {
    if (_isAllEventsLoading && !force) return;
    final requestId = ++_allEventsRequestId;
    _isAllEventsLoading = true;
    _isAllEventsLoadingMore = false;
    _hasAllEventsError = false;
    _allEventsPage = 0;
    _hasMoreAllEvents = true;
    notifyListeners();

    try {
      final page = await _repo.getAllEvents(
        page: 1,
        limit: _allEventsPageSize,
        search: _allSearch,
        date: _allDateParam,
        tags: _allTag,
      );
      if (requestId != _allEventsRequestId) return;
      _allEvents
        ..clear()
        ..addAll(page);
      _allEventsPage = 1;
      _hasMoreAllEvents = page.length >= _allEventsPageSize;
    } catch (e) {
      log('Error loading all events: $e');
      if (requestId != _allEventsRequestId) return;
      _hasAllEventsError = true;
    }
    _isAllEventsLoading = false;
    notifyListeners();
  }

  /// Fetches the next page of all events and appends it, skipping duplicates.
  Future<void> loadMoreAllEvents() async {
    if (_isAllEventsLoading ||
        _isAllEventsLoadingMore ||
        !_hasMoreAllEvents ||
        _allEventsPage == 0) {
      return;
    }
    final requestId = _allEventsRequestId;
    _isAllEventsLoadingMore = true;
    notifyListeners();

    try {
      final next = await _repo.getAllEvents(
        page: _allEventsPage + 1,
        limit: _allEventsPageSize,
        search: _allSearch,
        date: _allDateParam,
        tags: _allTag,
      );
      if (requestId != _allEventsRequestId) return;
      final existingIds = _allEvents.map((e) => e.id).toSet();
      _allEvents.addAll(next.where((e) => existingIds.add(e.id)));
      _allEventsPage++;
      _hasMoreAllEvents = next.length >= _allEventsPageSize;
    } catch (e) {
      log('Error loading more events: $e');
    }
    _isAllEventsLoadingMore = false;
    notifyListeners();
  }

  /// Loads only the user's liked events (saved & attended screens).
  Future<void> loadLiked() async {
    _isLikedLoading = true;
    notifyListeners();
    try {
      _likedEvents =
          _hasIdentity
              ? await _repo.getUserLikedEvents(rollNo: _rollNo, email: _email)
              : <EventModel>[];
    } catch (e) {
      log('Error loading liked events: $e');
    }
    _isLikedLoading = false;
    notifyListeners();
  }

  /// Fetches the current user's feedback for every attended event.
  Future<void> loadAttendedFeedback() async {
    final events = attendedEvents;
    final results = await Future.wait(
      events.map((e) => _repo.getEventFeedback(e.id)),
    );
    for (var i = 0; i < events.length; i++) {
      final mine = results[i].where(
        (f) =>
            (f.studentId == _rollNo || f.studentId == _email) &&
            (f.feedback?.comment?.trim().isNotEmpty ?? false),
      );
      if (mine.isNotEmpty) {
        _feedbackByEventId[events[i].id] = mine.first.feedback!.comment!;
      }
    }
    notifyListeners();
  }

  Future<EventModel?> fetchEventDetails(String eventId) {
    final studentId =
        LoginStore.userData['_id']?.toString() ??
        LoginStore.userData['rollNo']?.toString() ??
        '';
    return _repo.getEventDetails(eventId, studentId: studentId);
  }

  // ---------------------------------------------------------------------------
  // Going / liked
  // ---------------------------------------------------------------------------
  bool isGoing(EventModel event) =>
      _likedEvents.any((e) => e.id == event.id) ||
      (event.userStatus?.isRegistered ?? false);

  /// Live interested count factoring in the current user's interaction.
  int interestedCount(EventModel event) {
    final baseCount = event.stats?.interested ?? event.likes;
    final initiallyLiked = _initialLikedEventIds.contains(event.id);
    final currentlyLiked = _likedEvents.any((e) => e.id == event.id);

    if (currentlyLiked && !initiallyLiked) return baseCount + 1;
    if (!currentlyLiked && initiallyLiked) {
      return baseCount > 0 ? baseCount - 1 : 0;
    }
    return baseCount;
  }

  /// Live going count factoring in the current user's registration.
  int goingCount(EventModel event) {
    final baseCount = event.stats?.going ?? event.registrants;
    final initiallyGoing = _initialGoingEventIds.contains(event.id);
    final currentlyGoing = isGoing(event);

    if (currentlyGoing && !initiallyGoing) return baseCount + 1;
    if (!currentlyGoing && initiallyGoing) {
      return baseCount > 0 ? baseCount - 1 : 0;
    }
    return baseCount;
  }

  /// Optimistically marks [event] as going / not going and syncs with the
  /// backend. Reverts and returns `false` if the backend call fails.
  Future<bool> setGoing(EventModel event, bool going) async {
    final previous = List<EventModel>.from(_likedEvents);
    _applyLiked(event, going);
    notifyListeners();

    final res = await _repo.toggleLikeEvent(
      rollNo: _likeRollNo,
      email: _likeEmail,
      eventId: event.id,
      like: going,
    );

    if (res == null) {
      _likedEvents = previous;
      notifyListeners();
      return false;
    }
    _applyLiked(event, res.like);
    notifyListeners();
    return true;
  }

  Future<bool> toggleGoing(EventModel event) =>
      setGoing(event, !_likedEvents.any((e) => e.id == event.id));

  void _applyLiked(EventModel event, bool liked) {
    if (liked) {
      if (!_likedEvents.any((e) => e.id == event.id)) _likedEvents.add(event);
    } else {
      _likedEvents.removeWhere((e) => e.id == event.id);
    }
  }

  // ---------------------------------------------------------------------------
  // Feedback
  // ---------------------------------------------------------------------------
  Future<bool> submitFeedback(EventModel event, String comment) async {
    try {
      await _repo.submitFeedback(
        rollNo: _rollNo,
        email: _email,
        eventId: event.id,
        feedback: EventFeedback(comment: comment),
      );
      _feedbackByEventId[event.id] = comment;
      notifyListeners();
      return true;
    } catch (e) {
      log('Error submitting feedback: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  /// Case-insensitive name / club / tag filter used by the saved & attended
  /// screens.
  static List<EventModel> filterEvents(List<EventModel> events, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return events;
    return events.where((e) {
      return e.name.toLowerCase().contains(q) ||
          e.clubOrg.toLowerCase().contains(q) ||
          e.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  /// Builds a strict, narrow-scoped weighted fuzzy search engine.
  void _rebuildFuzzyIndex() {
    if (_allIndexedEvents.isEmpty) return;
    _fuzzyEngine = Fuzzy<EventModel>(
      _allIndexedEvents,
      options: FuzzyOptions(
        keys: [
          WeightedKey(
            name: 'name',
            getter: (EventModel e) => e.name,
            weight: 0.55,
          ),
          WeightedKey(
            name: 'clubName',
            getter: (EventModel e) => e.clubOrg,
            weight: 0.25,
          ),
          WeightedKey(
            name: 'tags',
            getter: (EventModel e) => e.tags.join(' '),
            weight: 0.15,
          ),
          WeightedKey(
            name: 'description',
            getter: (EventModel e) => e.description ?? '',
            weight: 0.05,
          ),
        ],
        // Stricter threshold (0.0 is exact, 0.20 eliminates false positives)
        threshold: 0.20,
        findAllMatches: false,
        tokenize: true,
      ),
    );
  }

  /// Handles a search query change with instant local fuzzy search plus a
  /// debounced backend fallback.
  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      _searchQuery = '';
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _searchQuery = trimmed;
    _isSearching = true;
    notifyListeners();

    _performLocalSearch(trimmed);

    // Debounced remote search (300ms) for newly indexed/remote events
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performRemoteSearch(trimmed);
    });
  }

  void clearSearch() => onSearchChanged('');

  /// Strict local search: prioritizes titles, clubs, tags and word boundaries.
  void _performLocalSearch(String query) {
    final lowerQuery = query.toLowerCase();
    final Set<String> matchedIds = {};
    final List<EventModel> results = [];

    // Step 1: strict direct matching
    for (final event in _allIndexedEvents) {
      final nameWords = event.name.toLowerCase().split(_whitespaceRegex);
      final nameMatch =
          nameWords.any((w) => w.startsWith(lowerQuery)) ||
          event.name.toLowerCase().contains(lowerQuery);

      final clubWords = event.clubOrg.toLowerCase().split(_whitespaceRegex);
      final clubMatch =
          clubWords.any((w) => w.startsWith(lowerQuery)) ||
          event.clubOrg.toLowerCase().contains(lowerQuery);

      final tagsMatch = event.tags.any(
        (t) =>
            t.toLowerCase().startsWith(lowerQuery) ||
            t.toLowerCase() == lowerQuery,
      );

      // Description only matched for queries >= 3 chars on whole words/prefixes
      final descMatch =
          query.length >= 3 &&
          (event.description
                  ?.toLowerCase()
                  .split(_whitespaceRegex)
                  .any((w) => w.startsWith(lowerQuery)) ??
              false);

      if ((nameMatch || clubMatch || tagsMatch || descMatch) &&
          matchedIds.add(event.id)) {
        results.add(event);
      }
    }

    // Step 2: strict fuzzy search match (score <= 0.20)
    if (_fuzzyEngine != null && query.length >= 2) {
      for (final match in _fuzzyEngine!.search(query)) {
        if (match.score <= 0.20 && matchedIds.add(match.item.id)) {
          results.add(match.item);
        }
      }
    }

    if (_searchQuery == query) {
      _searchResults = results;
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Remote search sent to the backend to supplement the local cache.
  Future<void> _performRemoteSearch(String query) async {
    try {
      final remoteEvents = await _repo.getAllEvents(search: query);
      if (remoteEvents.isEmpty || _searchQuery != query) return;

      final existingIds = _searchResults.map((e) => e.id).toSet();
      final updated = List<EventModel>.from(_searchResults);
      for (final re in remoteEvents) {
        if (existingIds.add(re.id)) {
          updated.add(re);
          if (!_allIndexedEvents.any((e) => e.id == re.id)) {
            _allIndexedEvents.add(re);
          }
        }
      }
      _searchResults = updated;
      _isSearching = false;
      _rebuildFuzzyIndex();
      notifyListeners();
    } catch (_) {}
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
