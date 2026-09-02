import 'dart:async';
import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/clubs_fest_page.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_large_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_medium_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_small_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_popup.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_dev/pages/events/widgets/event_toggle_tiles.dart';
import 'package:onestop_dev/pages/events/widgets/events_compact_card.dart';
import 'package:onestop_dev/pages/events/widgets/events_home_shimmer.dart';
import 'package:onestop_dev/pages/events/widgets/section_header.dart';
import 'package:onestop_dev/pages/events_feed/events_appbar.dart';
import 'package:onestop_dev/repository/events_api_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_ui/index.dart';

/// The Events Homepage screen with live fuzzy search and backend API integration.
class EventsHomePage extends StatefulWidget {
  static const id = "/events/home";

  const EventsHomePage({super.key});

  @override
  State<EventsHomePage> createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  final EventsAPIRepository _apiRepo = EventsAPIRepository();

  List<EventModel> _todayEvents = [];
  List<EventModel> _trendingEvents = [];
  List<EventModel> _interestsEvents = [];
  List<EventModel> _exploreEvents = [];
  List<EventModel> _likedEvents = [];
  final Set<String> _initialLikedEventIds = {};
  final Set<String> _initialGoingEventIds = {};

  // Search & Fuzzy Indexing
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  List<EventModel> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;
  Fuzzy<EventModel>? _fuzzyEngine;
  List<EventModel> _allIndexedEvents = [];

  bool _isLoading = true;
  bool _hasError = false;
  int _allEventsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAllHomeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAllHomeData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final rollNo = LoginStore.userData['rollNo'] ?? '';
      final email = LoginStore.userData['outlookEmail'] ?? '';

      final results = await Future.wait([
        _apiRepo.getAllEvents(feedType: 'TODAY'),
        _apiRepo.getAllEvents(feedType: 'TRENDING'),
        _apiRepo.getAllEvents(feedType: 'INTERESTS'),
        _apiRepo.getAllEvents(limit: 10),
        if (rollNo.isNotEmpty || email.isNotEmpty)
          _apiRepo.getUserLikedEvents(rollNo: rollNo, email: email)
        else
          Future.value(<EventModel>[]),
      ]);

      if (mounted) {
        setState(() {
          _todayEvents = results[0];
          _trendingEvents = results[1];
          _interestsEvents = results[2];
          _exploreEvents = results[3];
          _likedEvents = results[4];
          _allEventsCount =
              _exploreEvents.length +
              _todayEvents.length +
              _trendingEvents.length;
          _isLoading = false;
          _hasError = false;

          // Snapshot initial liked & going IDs to avoid double counting baseline
          _initialLikedEventIds.clear();
          for (var e in _likedEvents) {
            _initialLikedEventIds.add(e.id);
          }
          _initialGoingEventIds.clear();

          // Index all events for fast multi-field fuzzy search with unique deterministic key
          final Map<String, EventModel> uniqueEvents = {};
          for (var list in [
            _todayEvents,
            _trendingEvents,
            _interestsEvents,
            _exploreEvents,
            _likedEvents,
          ]) {
            for (var e in list) {
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
        });
      }
    } catch (e) {
      log('Error loading home data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = _allIndexedEvents.isEmpty;
        });
      }
    }
  }

  /// Builds a strict, narrow-scoped weighted fuzzy search engine
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
        threshold:
            0.20, // Stricter threshold (0.0 is exact, 0.20 eliminates false positives)
        findAllMatches: false,
        tokenize: true,
      ),
    );
  }

  /// Handles search query change with instant local fuzzy search + debounced backend fallback
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _searchQuery = '';
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _searchQuery = trimmed;
      _isSearching = true;
    });

    // 1. Instant local fuzzy search
    _performLocalSearch(trimmed);

    // 2. Debounced remote search (300ms) for newly indexed/remote events
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await _performRemoteSearch(trimmed);
    });
  }

  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  /// Optimized strict local search: prioritizes titles, clubs, tags, and word boundaries
  void _performLocalSearch(String query) {
    final lowerQuery = query.toLowerCase();
    final Set<String> matchedIds = {};
    final List<EventModel> results = [];

    // Step 1: Strict Direct Matching (Title, Club, Tag Prefix/Match, Description Word Boundary)
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

      if (nameMatch || clubMatch || tagsMatch || descMatch) {
        if (matchedIds.add(event.id)) {
          results.add(event);
        }
      }
    }

    // Step 2: Strict Fuzzy search match (score <= 0.20)
    if (_fuzzyEngine != null && query.length >= 2) {
      final fuzzyMatches = _fuzzyEngine!.search(query);
      for (final match in fuzzyMatches) {
        if (match.score <= 0.20 && matchedIds.add(match.item.id)) {
          results.add(match.item);
        }
      }
    }

    if (mounted && _searchQuery == query) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  /// Remote search query sent to backend API to supplement local cache
  Future<void> _performRemoteSearch(String query) async {
    try {
      final remoteEvents = await _apiRepo.getAllEvents(search: query);
      if (remoteEvents.isNotEmpty && mounted && _searchQuery == query) {
        final Set<String> existingIds = _searchResults.map((e) => e.id).toSet();
        final updated = List<EventModel>.from(_searchResults);

        for (final re in remoteEvents) {
          if (existingIds.add(re.id)) {
            updated.add(re);
            if (!_allIndexedEvents.any((e) => e.id == re.id)) {
              _allIndexedEvents.add(re);
            }
          }
        }

        setState(() {
          _searchResults = updated;
          _isSearching = false;
        });
        _rebuildFuzzyIndex();
      }
    } catch (_) {}
  }

  Future<void> _handleToggleLike(EventModel event) async {
    final rollNo =
        LoginStore.userData['rollNo']?.toString() ??
        LoginStore.userData['rollno']?.toString() ??
        LoginStore.userData['rollNumber']?.toString() ??
        'guest';
    final email =
        LoginStore.userData['outlookEmail']?.toString() ??
        LoginStore.userData['email']?.toString() ??
        'guest@iitg.ac.in';

    final isCurrentlyLiked = _likedEvents.any((e) => e.id == event.id);
    final targetState = !isCurrentlyLiked;

    // Optimistic UI update
    setState(() {
      if (targetState) {
        if (!_likedEvents.any((e) => e.id == event.id)) {
          _likedEvents.add(event);
        }
      } else {
        _likedEvents.removeWhere((e) => e.id == event.id);
      }
    });

    try {
      final res = await _apiRepo.toggleLikeEvent(
        rollNo: rollNo,
        email: email,
        eventId: event.id,
        like: targetState,
      );

      if (mounted) {
        if (res != null) {
          setState(() {
            if (res.like) {
              if (!_likedEvents.any((e) => e.id == event.id)) {
                _likedEvents.add(event);
              }
            } else {
              _likedEvents.removeWhere((e) => e.id == event.id);
            }
          });
        }
        showSnackBar(targetState ? "Marked as going!" : "Removed from going");
      }
    } catch (_) {
      if (mounted) {
        showSnackBar(targetState ? "Marked as going!" : "Removed from going");
      }
    }
  }

  Future<void> _openEventPopup(EventModel event) async {
    final isCurrentlyGoing =
        _likedEvents.any((e) => e.id == event.id) ||
        (event.userStatus?.isRegistered ?? false);

    await showEventPopup(
      context,
      event: event,
      isInitiallyInterested: isCurrentlyGoing,
      isInitiallyRegistered: event.userStatus?.isRegistered ?? false,
      onStatusChanged: (isInterested, isRegistered) {
        if (mounted) {
          setState(() {
            if (isInterested || isRegistered) {
              if (!_likedEvents.any((e) => e.id == event.id)) {
                _likedEvents.add(event);
              }
            } else {
              _likedEvents.removeWhere((e) => e.id == event.id);
            }
          });
        }
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  /// Computes the live interested count factoring in the current user's interaction
  int _getEventInterestedCount(EventModel event) {
    final baseCount = event.stats?.interested ?? event.likes;
    final initiallyLiked = _initialLikedEventIds.contains(event.id);
    final currentlyLiked = _likedEvents.any((e) => e.id == event.id);

    if (currentlyLiked && !initiallyLiked) {
      return baseCount + 1;
    } else if (!currentlyLiked && initiallyLiked) {
      return (baseCount > 0) ? baseCount - 1 : 0;
    }
    return baseCount;
  }

  /// Computes the live going count factoring in the current user's registration
  int _getEventGoingCount(EventModel event) {
    final baseCount = event.stats?.going ?? event.registrants;
    final initiallyGoing = _initialGoingEventIds.contains(event.id);
    final currentlyGoing =
        _likedEvents.any((e) => e.id == event.id) ||
        (event.userStatus?.isRegistered == true);

    if (currentlyGoing && !initiallyGoing) {
      return baseCount + 1;
    } else if (!currentlyGoing && initiallyGoing) {
      return (baseCount > 0) ? baseCount - 1 : 0;
    }
    return baseCount;
  }

  @override
  Widget build(BuildContext context) {
    final isSearchingActive = _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: OColor.gray100,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAllHomeData,
          color: OColor.green600,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: OSpacing.m),

                // Live Interactive Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                  child: EventSearchBar(
                    placeholder:
                        'Search events by name, club, tags or description',
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    isLoading: _isSearching,
                    onChanged: _onSearchChanged,
                    onClear: () => _onSearchChanged(''),
                  ),
                ),
                const SizedBox(height: OSpacing.s),

                // If user is searching, show search results section with Large Cards
                if (isSearchingActive)
                  _buildSearchResultsSection()
                else ...[
                  // Toggle tiles
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                    child: EventToggleTiles(
                      allEventsCount: _isLoading ? 0 : _allEventsCount,
                      onAllEventsTap: () {
                        // TODO: Deep-link directly to "All" category tab in EventsScreenWrapper or dedicated All Events screen
                        Navigator.pushNamed(context, EventsScreenWrapper.id);
                      },
                      onSavedEventsTap: () {
                        // TODO: Deep-link directly to "Saved" category tab (index 0) in EventsScreenWrapper or dedicated Saved Events screen
                        Navigator.pushNamed(context, EventsScreenWrapper.id);
                      },
                    ),
                  ),
                  const SizedBox(height: OSpacing.l),

                  if (_isLoading)
                    const EventsHomeShimmer()
                  else if (_hasError && _allIndexedEvents.isEmpty)
                    _buildErrorState()
                  else ...[
                    // Happening Today
                    if (_todayEvents.isNotEmpty) ...[
                      _buildHappeningTodaySection(_todayEvents),
                      const SizedBox(height: OSpacing.l),
                    ],

                    // Trending Events
                    if (_trendingEvents.isNotEmpty) ...[
                      _buildTrendingEventsSection(_trendingEvents),
                      const SizedBox(height: OSpacing.l),
                    ],

                    // Your Interests
                    if (_interestsEvents.isNotEmpty) ...[
                      _buildYourInterestsSection(_interestsEvents),
                      const SizedBox(height: OSpacing.l),
                    ],

                    // Saved / Attended Events
                    if (_likedEvents.isNotEmpty) ...[
                      _buildRecentlyAttendedSection(_likedEvents),
                      const SizedBox(height: OSpacing.l),
                    ],

                    // Explore
                    _buildExploreSection(
                      _exploreEvents.isNotEmpty
                          ? _exploreEvents
                          : _generateMockEvents(),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Error & offline state with retry button
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 48,
          horizontal: OSpacing.m,
        ),
        child: Column(
          children: [
            Icon(
              FluentIcons.error_circle_24_regular,
              size: 48,
              color: OColor.gray400,
            ),
            const SizedBox(height: OSpacing.s),
            OText(
              text: 'Unable to load events',
              style: OTextStyle.bodyMedium.copyWith(color: OColor.gray700),
            ),
            const SizedBox(height: OSpacing.xxs),
            OText(
              text: 'Please check your internet connection and try again.',
              style: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: OSpacing.m),
            GestureDetector(
              onTap: _loadAllHomeData,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: OSpacing.m,
                  vertical: OSpacing.s,
                ),
                decoration: BoxDecoration(
                  color: OColor.green600,
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FluentIcons.arrow_clockwise_24_regular,
                      size: 16,
                      color: OColor.white,
                    ),
                    const SizedBox(width: OSpacing.xs),
                    OText(
                      text: 'Retry',
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Search Results Section using the large card from "Your Interests"
  Widget _buildSearchResultsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: OSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OText(
                    text: 'Search Results',
                    style: OTextStyle.headingMedium.copyWith(
                      color: OColor.gray800,
                    ),
                  ),
                  const SizedBox(height: OSpacing.xxs),
                  OText(
                    text:
                        '${_searchResults.length} ${_searchResults.length == 1 ? "event" : "events"} found',
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                  _onSearchChanged('');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: OColor.gray200,
                    borderRadius: BorderRadius.circular(OCornerRadius.s),
                  ),
                  child: OText(
                    text: 'Clear',
                    style: OTextStyle.labelSmall.copyWith(
                      color: OColor.gray700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isSearching) ...[
            const SizedBox(height: OSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                minHeight: 3,
                backgroundColor: OColor.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(OColor.green600),
              ),
            ),
          ],
          const SizedBox(height: OSpacing.m),

          if (_isSearching && _searchResults.isEmpty)
            Column(
              children: const [
                EventLargeCardShimmer(),
                SizedBox(height: OSpacing.s),
                EventLargeCardShimmer(),
              ],
            )
          else if (_searchResults.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(
                      FluentIcons.search_24_regular,
                      size: 48,
                      color: OColor.gray400,
                    ),
                    const SizedBox(height: OSpacing.s),
                    OText(
                      text: 'No events found for "$_searchQuery"',
                      style: OTextStyle.bodyMedium.copyWith(
                        color: OColor.gray700,
                      ),
                    ),
                    const SizedBox(height: OSpacing.xxs),
                    OText(
                      text:
                          'Try searching by a club name, category, or keyword.',
                      style: OTextStyle.bodySmall.copyWith(
                        color: OColor.gray500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children:
                  _searchResults.map((event) {
                    final isGoing =
                        _likedEvents.any((e) => e.id == event.id) ||
                        (event.userStatus?.isRegistered ?? false);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: OSpacing.s),
                      child: RepaintBoundary(
                        child: EventListingLargeCard(
                          event: event,
                          interestedCount: _getEventInterestedCount(event),
                          isGoing: isGoing,
                          onTap: () => _openEventPopup(event),
                          onGoingTap: () => _handleToggleLike(event),
                        ),
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  /// Top app bar with date, user greeting, and icon
  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final daySuffix = _getDaySuffix(now.day);
    final formattedDate =
        '${DateFormat('EEEE, d').format(now)}$daySuffix ${DateFormat('MMMM').format(now)}';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OSpacing.m,
      ).copyWith(top: OSpacing.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: date and greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OText(
                text: formattedDate,
                style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
              ),
              const SizedBox(height: OSpacing.xxs),
              OText(
                text: 'Events',
                style: OTextStyle.headingLarge.copyWith(color: OColor.gray800),
              ),
            ],
          ),
          // Right: circular icon button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClubsFestPage()),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: OColor.white,
                shape: BoxShape.circle,
                border: Border.all(color: OColor.gray200),
              ),
              child: Icon(
                FluentIcons.grid_24_regular,
                size: 24,
                color: OColor.gray800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Happening Today section — horizontal scroll of small event cards
  Widget _buildHappeningTodaySection(List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: SectionHeader(
            icon: FluentIcons.calendar_24_regular,
            title: 'Happening Today',
          ),
        ),
        const SizedBox(height: OSpacing.s),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final event in events) ...[
                  RepaintBoundary(
                    child: EventListingSmallCard(
                      event: event,
                      isGoing:
                          _likedEvents.any((e) => e.id == event.id) ||
                          (event.userStatus?.isRegistered ?? false),
                      onTap: () => _openEventPopup(event),
                    ),
                  ),
                  if (event != events.last) const SizedBox(width: OSpacing.s),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Trending Events section — horizontal scroll of medium event cards
  Widget _buildTrendingEventsSection(List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: SectionHeader(
            icon: FluentIcons.fire_24_regular,
            title: 'Trending Events',
            actionLabel: 'Learn More',
            onActionTap: () {
              Navigator.pushNamed(context, EventsScreenWrapper.id);
            },
          ),
        ),
        const SizedBox(height: OSpacing.s),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final event in events) ...[
                  RepaintBoundary(
                    child: EventListingMediumCard(
                      event: event,
                      goingCount: _getEventGoingCount(event),
                      onTap: () => _openEventPopup(event),
                    ),
                  ),
                  if (event != events.last) const SizedBox(width: OSpacing.s),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Your Interests section — vertical list of large event cards
  Widget _buildYourInterestsSection(List<EventModel> events) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: FluentIcons.person_24_regular,
            title: 'Your Interests',
            actionLabel: 'Personalize',
            actionIcon: FluentIcons.settings_16_regular,
            onActionTap: () {
              Navigator.pushNamed(context, EventsScreenWrapper.id);
            },
          ),
          const SizedBox(height: OSpacing.s),
          ...events.take(3).map((event) {
            final isGoing =
                _likedEvents.any((e) => e.id == event.id) ||
                (event.userStatus?.isRegistered ?? false);
            return Padding(
              padding: const EdgeInsets.only(bottom: OSpacing.s),
              child: RepaintBoundary(
                child: EventListingLargeCard(
                  event: event,
                  interestedCount: _getEventInterestedCount(event),
                  isGoing: isGoing,
                  onTap: () => _openEventPopup(event),
                  onGoingTap: () => _handleToggleLike(event),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Recently Attended section — horizontal scroll of compact cards
  Widget _buildRecentlyAttendedSection(List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: SectionHeader(
            icon: FluentIcons.history_24_regular,
            title: 'Saved & Attended',
          ),
        ),
        const SizedBox(height: OSpacing.s),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final event in events) ...[
                  RepaintBoundary(
                    child: EventsCompactCard(
                      event: event,
                      showFeedbackButton: true,
                      onTap: () => _openEventPopup(event),
                      onFeedbackTap: () {
                        _openEventPopup(event);
                      },
                    ),
                  ),
                  if (event != events.last) const SizedBox(width: OSpacing.s),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Explore section — vertical list of large event cards
  Widget _buildExploreSection(List<EventModel> events) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: FluentIcons.compass_northwest_24_regular,
            title: 'Explore',
          ),
          const SizedBox(height: OSpacing.s),
          ...events.take(5).map((event) {
            final isGoing =
                _likedEvents.any((e) => e.id == event.id) ||
                (event.userStatus?.isRegistered ?? false);
            return Padding(
              padding: const EdgeInsets.only(bottom: OSpacing.s),
              child: RepaintBoundary(
                child: EventListingLargeCard(
                  event: event,
                  interestedCount: _getEventInterestedCount(event),
                  isGoing: isGoing,
                  onTap: () => _openEventPopup(event),
                  onGoingTap: () => _handleToggleLike(event),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Generate mock events matching the Figma placeholder data
  List<EventModel> _generateMockEvents() {
    return List.generate(3, (index) {
      return EventModel(
        id: 'mock_$index',
        clubId: 'club_$index',
        name: 'Rangmunch - Inter Hostel Stand Up',
        description:
            'A stand-up comedy event featuring talented comedians from across hostels.',
        clubName: "Students' Web Committee",
        tags: ['Cultural', 'Comedy'],
        startTime: DateTime.now().copyWith(hour: 20, minute: 0),
        endTime: DateTime.now().copyWith(hour: 22, minute: 0),
        date: DateTime.now(),
        location: 'Main Auditorium',
      );
    });
  }

  /// Returns ordinal suffix for a day number (1st, 2nd, 3rd, etc.)
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
