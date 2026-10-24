import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/saved/attended_events.dart';
import 'package:onestop_dev/pages/events/providers/events_provider.dart';
import 'package:onestop_dev/pages/events/widgets/event_listing_large_card.dart';
import 'package:onestop_dev/pages/events/widgets/event_popup.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Lists the events the user has liked / marked as going, split into
/// "Happening Today" and "Happening Later".
class SavedEvents extends StatefulWidget {
  static const id = "/events/saved";
  const SavedEvents({super.key});
  @override
  State<SavedEvents> createState() => _SavedEventsState();
}

class _SavedEventsState extends State<SavedEvents> {
  // Reads (non-subscribing); [build] subscribes via `context.watch`.
  EventsProvider get _p => context.read<EventsProvider>();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _p.loadLiked());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleUnlike(EventModel event) async {
    final success = await _p.setGoing(event, false);
    if (!mounted) return;
    showSnackBar(
      success
          ? "Removed from saved events"
          : "Couldn't update your saved events",
    );
  }

  Future<void> _openEventPopup(EventModel event) {
    return showEventPopup(
      context,
      event: event,
      isInitiallyInterested: true,
      isInitiallyRegistered: event.userStatus?.isRegistered ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();
    final todayEvents = EventsProvider.filterEvents(
      provider.savedTodayEvents,
      _searchQuery,
    );
    final laterEvents = EventsProvider.filterEvents(
      provider.savedLaterEvents,
      _searchQuery,
    );

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(TablerIcons.arrow_left, size: 24, color: OColor.green800),
        ),
        title: Text(
          "Saved Events",
          style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _p.loadLiked,
        color: OColor.green600,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            OSpacing.m,
            OSpacing.m,
            OSpacing.m,
            OSpacing.xl,
          ),
          children: [
            // EventSearchBar(
            //   placeholder: 'Search Events',
            //   controller: _searchController,
            //   onChanged: (q) => setState(() => _searchQuery = q.trim()),
            //   onClear: () => setState(() => _searchQuery = ''),
            // ),
            // const SizedBox(height: OSpacing.s),
            _buildAttendedTile(),
            const SizedBox(height: OSpacing.xl),
            if (provider.isLikedLoading && provider.likedEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (todayEvents.isEmpty && laterEvents.isEmpty)
              _buildEmptyState()
            else ...[
              if (todayEvents.isNotEmpty)
                _buildSection(
                  title: 'Happening Today',
                  events: todayEvents,
                  showDot: true,
                ),
              if (todayEvents.isNotEmpty && laterEvents.isNotEmpty)
                const SizedBox(height: OSpacing.xl),
              if (laterEvents.isNotEmpty)
                _buildSection(title: 'Happening Later', events: laterEvents),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttendedTile() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AttendedEvents.id),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Icon(
              FluentIcons.calendar_clock_24_regular,
              size: 24,
              color: OColor.green600,
            ),
            const SizedBox(width: OSpacing.xs),
            Expanded(
              child: OText(
                text: 'Events Attended',
                style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
              ),
            ),
            Icon(
              FluentIcons.chevron_right_24_regular,
              size: 24,
              color: OColor.gray800,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<EventModel> events,
    bool showDot = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showDot) ...[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: OColor.blue500,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: OSpacing.xs),
            ],
            OText(
              text: title,
              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
            ),
          ],
        ),
        const SizedBox(height: OSpacing.s),
        for (final event in events)
          Padding(
            padding: const EdgeInsets.only(bottom: OSpacing.s),
            child: RepaintBoundary(
              child: EventListingLargeCard(
                event: event,
                interestedCount: _p.interestedCount(event),
                isGoing: true,
                onTap: () => _openEventPopup(event),
                onGoingTap: () => _handleUnlike(event),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(FluentIcons.heart_24_regular, size: 48, color: OColor.gray400),
          const SizedBox(height: OSpacing.s),
          OText(
            text:
                _searchQuery.isEmpty
                    ? 'No saved events yet'
                    : 'No saved events match "$_searchQuery"',
            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray700),
          ),
        ],
      ),
    );
  }
}
