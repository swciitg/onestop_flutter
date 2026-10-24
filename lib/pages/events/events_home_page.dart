import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/all_events.dart';
import 'package:onestop_dev/pages/events/providers/events_provider.dart';
import 'package:onestop_dev/pages/events/saved/saved_events.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_large_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_medium_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_small_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_popup.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_dev/pages/events/widgets/event_toggle_tiles.dart';
import 'package:onestop_dev/pages/events/widgets/events_compact_card.dart';
import 'package:onestop_dev/pages/events/widgets/events_home_shimmer.dart';
import 'package:onestop_dev/pages/events/widgets/section_header.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// The Events Homepage screen with live fuzzy search and backend API integration.
class EventsHomePage extends StatefulWidget {
  static const id = "/events/home";

  const EventsHomePage({super.key});

  @override
  State<EventsHomePage> createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  // Reads (non-subscribing); [build] subscribes via `context.watch`.
  EventsProvider get _p => context.read<EventsProvider>();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _p.clearSearch();
      _p.loadHome();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleToggleLike(EventModel event) async {
    final targetState = !_p.likedEvents.any((e) => e.id == event.id);
    final success = await _p.toggleGoing(event);
    if (!mounted) return;
    showSnackBar(
      !success
          ? "Couldn't update your going status"
          : targetState
          ? "Marked as going!"
          : "Removed from going",
    );
  }

  Future<void> _openEventPopup(EventModel event) {
    return showEventPopup(
      context,
      event: event,
      isInitiallyInterested: _p.isGoing(event),
      isInitiallyRegistered: event.userStatus?.isRegistered ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();
    final isSearchingActive = provider.searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: OColor.gray100,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _p.loadHome,
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
                    isLoading: _p.isSearching,
                    onChanged: _p.onSearchChanged,
                    onClear: () => _p.onSearchChanged(''),
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
                      allEventsCount:
                          provider.isHomeLoading ? 0 : provider.allEventsCount,
                      onAllEventsTap: () {
                        Navigator.pushNamed(context, AllEvents.id);
                      },
                      onSavedEventsTap: () {
                        Navigator.pushNamed(context, SavedEvents.id);
                      },
                    ),
                  ),
                  const SizedBox(height: OSpacing.l),

                  if (provider.isHomeLoading)
                    const EventsHomeShimmer()
                  else if (provider.hasHomeError && !provider.hasIndexedEvents)
                    _buildErrorState()
                  else ...[
                    // Happening Today
                    if (provider.todayEvents.isNotEmpty) ...[
                      _buildHappeningTodaySection(provider.todayEvents),
                      const SizedBox(height: OSpacing.l),
                    ],

                    // Trending Events
                    if (provider.trendingEvents.isNotEmpty) ...[
                      _buildTrendingEventsSection(provider.trendingEvents),
                      const SizedBox(height: OSpacing.l),
                    ],

                    // Saved / Attended Events
                    if (_p.likedEvents.isNotEmpty) ...[
                      _buildRecentlyAttendedSection(_p.likedEvents),
                      const SizedBox(height: OSpacing.l),
                    ],

                    // Explore
                    provider.exploreEvents.isNotEmpty
                        ? _buildExploreSection(provider.exploreEvents)
                        : Container(color: Colors.red, height: 10, width: 50),
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
              onTap: _p.loadHome,
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

  /// Search Results Section using the large event card
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
                        '${_p.searchResults.length} ${_p.searchResults.length == 1 ? "event" : "events"} found',
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                  _p.onSearchChanged('');
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
          if (_p.isSearching) ...[
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

          if (_p.isSearching && _p.searchResults.isEmpty)
            Column(
              children: const [
                EventLargeCardShimmer(),
                SizedBox(height: OSpacing.s),
                EventLargeCardShimmer(),
              ],
            )
          else if (_p.searchResults.isEmpty)
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
                      text: 'No events found for "${_p.searchQuery}"',
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
                  _p.searchResults.map((event) {
                    final isGoing = _p.isGoing(event);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: OSpacing.s),
                      child: RepaintBoundary(
                        child: EventListingLargeCard(
                          event: event,
                          interestedCount: _p.interestedCount(event),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ClubsFestPage()),
              // );
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
                Icons.person_outlined,
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
                      isGoing: _p.isGoing(event),
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
              // Navigator.pushNamed(context, EventsScreenWrapper.id);
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
                      goingCount: _p.goingCount(event),
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
            final isGoing = _p.isGoing(event);
            return Padding(
              padding: const EdgeInsets.only(bottom: OSpacing.s),
              child: RepaintBoundary(
                child: EventListingLargeCard(
                  event: event,
                  interestedCount: _p.interestedCount(event),
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
  // List<EventModel> _generateMockEvents() {
  //   return List.generate(3, (index) {
  //     return EventModel(
  //       id: 'mock_$index',
  //       clubId: 'club_$index',
  //       name: 'Rangmunch - Inter Hostel Stand Up',
  //       description:
  //           'A stand-up comedy event featuring talented comedians from across hostels.',
  //       clubName: "Students' Web Committee",
  //       tags: ['Cultural', 'Comedy'],
  //       startTime: DateTime.now().copyWith(hour: 20, minute: 0),
  //       endTime: DateTime.now().copyWith(hour: 22, minute: 0),
  //       date: DateTime.now(),
  //       location: 'Main Auditorium',
  //     );
  //   });
  // }

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
