import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/providers/events_provider.dart';
import 'package:onestop_dev/pages/events/widgets/event_popup.dart';
import 'package:onestop_dev/pages/events/widgets/event_search_bar.dart';
import 'package:onestop_dev/pages/events/widgets/events_attended_card.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Past events the user marked as going, split into "Recently Attended"
/// (ended within the last week) and "Attended in the Past".
class AttendedEvents extends StatefulWidget {
  static const id = "/events/attended";
  const AttendedEvents({super.key});

  @override
  State<AttendedEvents> createState() => _AttendedEventsState();
}

class _AttendedEventsState extends State<AttendedEvents> {
  static const _recentWindow = Duration(days: 7);

  // Reads (non-subscribing); [build] subscribes via `context.watch`.
  EventsProvider get _p => context.read<EventsProvider>();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await _p.loadLiked();
    await _p.loadAttendedFeedback();
  }

  Future<void> _submitFeedback(EventModel event) async {
    final controller = TextEditingController();
    final comment = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: OColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.fromLTRB(
              OSpacing.m,
              OSpacing.m,
              OSpacing.m,
              MediaQuery.of(ctx).viewInsets.bottom + OSpacing.m,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OText(
                  text: 'Feedback for ${event.name}',
                  style: OTextStyle.headingSmall.copyWith(
                    color: OColor.gray800,
                  ),
                ),
                const SizedBox(height: OSpacing.s),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'How was the event?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: OSpacing.s),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: OColor.green600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                    child: OText(
                      text: 'Submit',
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
    controller.dispose();
    if (comment == null || comment.isEmpty) return;

    final success = await _p.submitFeedback(event, comment);
    if (!mounted) return;
    showSnackBar(
      success ? 'Feedback submitted' : "Couldn't submit your feedback",
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
    final events = EventsProvider.filterEvents(
      provider.attendedEvents,
      _searchQuery,
    );
    final cutoff = DateTime.now().subtract(_recentWindow);
    final recent = events.where((e) => e.endDateTime.isAfter(cutoff)).toList();
    final past = events.where((e) => !e.endDateTime.isAfter(cutoff)).toList();

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(TablerIcons.arrow_left, size: 24, color: OColor.green800),
        ),
        title: Text(
          "Events Attended",
          style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
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
            const SizedBox(height: OSpacing.l),
            if (provider.isLikedLoading && provider.likedEvents.isEmpty)
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
                            ? 'No attended events yet'
                            : 'No attended events match "$_searchQuery"',
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.gray700,
                    ),
                  ),
                ),
              )
            else ...[
              if (recent.isNotEmpty) _buildSection('Recently Attended', recent),
              if (recent.isNotEmpty && past.isNotEmpty)
                const SizedBox(height: OSpacing.xl),
              if (past.isNotEmpty) _buildSection('Attended in the Past', past),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: title,
          style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.s),
        for (final event in events)
          Padding(
            padding: const EdgeInsets.only(bottom: OSpacing.xs),
            child: EventsAttendedCard(
              event: event,
              submittedFeedback: _p.feedbackFor(event.id),
              onTap: () => _openEventPopup(event),
              onFeedbackTap: () => _submitFeedback(event),
            ),
          ),
      ],
    );
  }
}
