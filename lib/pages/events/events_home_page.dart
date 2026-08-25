import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_large_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_medium_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_small_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_dev/pages/events/widgets/event_toggle_tiles.dart';
import 'package:onestop_dev/pages/events/widgets/events_compact_card.dart';
import 'package:onestop_dev/pages/events/widgets/section_header.dart';
import 'package:onestop_ui/index.dart';

/// The new Events Homepage screen, matching the Figma design.
///
/// A scrollable page composed of:
/// - Header (title + date + profile avatar)
/// - Search bar
/// - Toggle tiles (All Events / Saved Events)
/// - Happening Today (horizontal scroll of small cards)
/// - Trending Events (horizontal scroll of medium cards)
/// - Your Interests (vertical list of large cards)
/// - Recently Attended (horizontal scroll of compact cards)
/// - Explore (vertical list of large cards)
class EventsHomePage extends StatelessWidget {
  const EventsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockEvents = _generateMockEvents();

    return Scaffold(
      backgroundColor: OColor.gray100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: OSpacing.m),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                child: EventSearchBar(
                  placeholder: 'Placeholder Text',
                  onTap: () {
                    // TODO: Navigate to search
                  },
                ),
              ),
              const SizedBox(height: OSpacing.s),

              // Toggle tiles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                child: EventToggleTiles(
                  allEventsCount: 56,
                  onAllEventsTap: () {
                    // TODO: Navigate to all events
                  },
                  onSavedEventsTap: () {
                    // TODO: Navigate to saved events
                  },
                ),
              ),
              const SizedBox(height: OSpacing.l),

              // Happening Today
              _buildHappeningTodaySection(mockEvents),
              const SizedBox(height: OSpacing.l),

              // Trending Events
              _buildTrendingEventsSection(mockEvents),
              const SizedBox(height: OSpacing.l),

              // Your Interests
              _buildYourInterestsSection(mockEvents),
              const SizedBox(height: OSpacing.l),

              // Recently Attended
              _buildRecentlyAttendedSection(mockEvents),
              const SizedBox(height: OSpacing.l),

              // Explore
              _buildExploreSection(mockEvents),
            ],
          ),
        ),
      ),
    );
  }

  /// Header: "Events" title + day/date + profile avatar
  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final dayDate = DateFormat('d').format(now);
    final daySuffix = _getDaySuffix(int.parse(dayDate));
    final month = DateFormat('MMMM').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m)
          .copyWith(top: OSpacing.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              OText(
                text: 'Events',
                style: OTextStyle.headingLarge.copyWith(
                  color: OColor.gray800,
                ),
              ),
              const SizedBox(width: OSpacing.m),
              OText(
                text: '$dayName, $dayDate$daySuffix $month',
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.gray600,
                ),
              ),
            ],
          ),
          // Profile avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: OColor.white,
              shape: BoxShape.circle,
              border: Border.all(color: OColor.gray200),
            ),
            child: Icon(
              FluentIcons.person_24_regular,
              size: 24,
              color: OColor.gray800,
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
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: OSpacing.s),
            itemBuilder: (context, index) {
              return EventListingSmallCard(
                event: events[index],
                isGoing: index == 0,
                onTap: () {
                  // TODO: Navigate to event details
                },
              );
            },
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
              // TODO: Navigate to trending
            },
          ),
        ),
        const SizedBox(height: OSpacing.s),
        SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: OSpacing.s),
            itemBuilder: (context, index) {
              return EventListingMediumCard(
                event: events[index],
                goingCount: 350,
                onTap: () {
                  // TODO: Navigate to event details
                },
              );
            },
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
              // TODO: Navigate to personalization
            },
          ),
          const SizedBox(height: OSpacing.s),
          ...events.take(3).map((event) {
            return Padding(
              padding: const EdgeInsets.only(bottom: OSpacing.s),
              child: EventListingLargeCard(
                event: event,
                interestedCount: 350,
                onTap: () {
                  // TODO: Navigate to event details
                },
                onGoingTap: () {
                  // TODO: Toggle going status
                },
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
            title: 'Recently Attended',
          ),
        ),
        const SizedBox(height: OSpacing.s),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: OSpacing.s),
            itemBuilder: (context, index) {
              return EventsCompactCard(
                event: events[index],
                showFeedbackButton: true,
                onTap: () {
                  // TODO: Navigate to event details
                },
                onFeedbackTap: () {
                  // TODO: Open feedback form
                },
              );
            },
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
          ...events.take(3).map((event) {
            return Padding(
              padding: const EdgeInsets.only(bottom: OSpacing.s),
              child: EventListingLargeCard(
                event: event,
                interestedCount: 350,
                onTap: () {
                  // TODO: Navigate to event details
                },
                onGoingTap: () {
                  // TODO: Toggle going status
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Generate mock events matching the Figma placeholder data
  List<EventModel> _generateMockEvents() {
    return List.generate(5, (index) {
      return EventModel(
        id: 'mock_$index',
        title: 'Rangmunch - Inter Hostel Stand Up',
        description:
            'A stand-up comedy event featuring talented comedians from across hostels.',
        clubOrg: "Students' Web Committee",
        board: 'Cultural',
        startDateTime: DateTime.now().copyWith(hour: 20, minute: 0),
        endDateTime: DateTime.now().copyWith(hour: 22, minute: 0),
        venue: 'Main Auditorium',
        categories: ['Cultural', 'Comedy'],
        v: 0,
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
