import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_dev/pages/events/providers/events_admin_provider.dart';
import 'package:onestop_dev/pages/events/providers/events_provider.dart';
import 'package:onestop_dev/pages/events/widgets/event_popup.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_dev/pages/events/widgets/events_admin_card.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Posted events of the selected club that have already ended.
///
/// Expects an [EventsAdminProvider] above it in the tree.
class PastEventsPage extends StatefulWidget {
  const PastEventsPage({super.key});

  @override
  State<PastEventsPage> createState() => _PastEventsPageState();
}

class _PastEventsPageState extends State<PastEventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsAdminProvider>();
    final events = EventsProvider.filterEvents(
      provider.pastEvents,
      _searchQuery,
    );

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: OColor.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(TablerIcons.arrow_left, size: 24, color: OColor.green800),
        ),
        title: Text(
          'Past Events',
          style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: OColor.gray200),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: provider.fetchEvents,
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
            EventSearchBar(
              placeholder: 'Search Events',
              controller: _searchController,
              onChanged: (q) => setState(() => _searchQuery = q.trim()),
              onClear: () => setState(() => _searchQuery = ''),
            ),
            const SizedBox(height: OSpacing.m),
            if (provider.isLoadingEvents && provider.pastEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: OText(
                    text:
                        _searchQuery.isEmpty
                            ? 'No past events'
                            : 'No past events match "$_searchQuery"',
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.gray700,
                    ),
                  ),
                ),
              )
            else
              for (final event in events)
                Padding(
                  padding: const EdgeInsets.only(bottom: OSpacing.s),
                  child: AdminEventCard(
                    event: event,
                    onTap: () => showEventPopup(context, event: event),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
