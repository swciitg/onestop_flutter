import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/admin/create_edit_event_page.dart';
import 'package:onestop_dev/pages/events/providers/events_admin_provider.dart';
import 'package:onestop_dev/pages/events/widgets/events_draft_card.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Draft events of the selected club. Tapping a draft resumes editing it.
///
/// Expects an [EventsAdminProvider] above it in the tree.
class DraftsPage extends StatelessWidget {
  const DraftsPage({super.key});

  Future<void> _openDraft(BuildContext context, EventModel event) async {
    final provider = context.read<EventsAdminProvider>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider.value(
              value: provider,
              child: CreateEditEventPage(event: event),
            ),
      ),
    );
    provider.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsAdminProvider>();
    final drafts = provider.drafts;

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
          'Drafts',
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
            const _DraftExpiryBanner(),
            const SizedBox(height: OSpacing.s),
            if (provider.isLoadingEvents && drafts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (drafts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: OText(
                    text: 'No drafts yet',
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.gray700,
                    ),
                  ),
                ),
              )
            else
              for (final draft in drafts)
                Padding(
                  padding: const EdgeInsets.only(bottom: OSpacing.s),
                  child: EventsDraftCard(
                    event: draft,
                    onTap: () => _openDraft(context, draft),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _DraftExpiryBanner extends StatelessWidget {
  const _DraftExpiryBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OSpacing.xs),
      decoration: BoxDecoration(
        color: OColor.yellow100,
        borderRadius: BorderRadius.circular(OCornerRadius.s),
      ),
      child: Row(
        children: [
          Icon(FluentIcons.info_24_regular, size: 32, color: OColor.gray800),
          const SizedBox(width: OSpacing.m),
          Expanded(
            child: OText(
              text:
                  'EVERY DRAFT GETS DELETED AUTOMATICALLY AFTER A PERIOD OF 7 DAYS OF INACTIVITY.',
              style: OTextStyle.labelXSmall.copyWith(color: OColor.gray800),
            ),
          ),
        ],
      ),
    );
  }
}
