import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/event_toggle_tiles.dart' as tb;
import 'package:onestop_dev/pages/events/widgets/events_admin_card.dart';
import 'package:onestop_dev/pages/events/providers/events_admin_provider.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

import 'create_edit_event_page.dart';
import 'drafts_page.dart';
import 'past_events_page.dart';

/// The admin "Manage" page for the Events section.
///
/// Lists the club's posted events and links to the Past Events and Drafts
/// pages; admins can also create, edit and delete events.
/// Matches the Figma design node 1780-57725.
class AdminPage extends StatelessWidget {
  static const id = "/events/admin";

  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventsAdminProvider()..loadAdminData(),
      child: const _AdminView(),
    );
  }
}

class _AdminView extends StatefulWidget {
  const _AdminView();

  @override
  State<_AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<_AdminView> {
  // Reads (non-subscribing); [build] subscribes via `context.watch`.
  EventsAdminProvider get _p => context.read<EventsAdminProvider>();

  void _onAddEvent() {
    final provider = _p;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider.value(
              value: provider,
              child: const CreateEditEventPage(),
            ),
      ),
    );
  }

  void _onEditEvent(EventModel event) {
    final provider = _p;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider.value(
              value: provider,
              child: CreateEditEventPage(event: event),
            ),
      ),
    );
  }

  Future<void> _onDeleteEvent(EventModel event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: OColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(OCornerRadius.m),
            ),
            title: OText(
              text: 'Delete Event',
              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
            ),
            content: OText(
              text:
                  'Are you sure you want to delete "${EventFormatters.sanitizeText(event.title)}"? This action cannot be undone.',
              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: OText(
                  text: 'Cancel',
                  style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: OText(
                  text: 'Delete',
                  style: OTextStyle.labelMedium.copyWith(color: OColor.red500),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final deleted = await _p.deleteEvent(event);
      showSnackBar(
        deleted ? 'Event deleted successfully' : 'Failed to delete event',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<EventsAdminProvider>();
    return Scaffold(
      backgroundColor: OColor.white,
      body: SafeArea(
        child:
            _p.isLoading
                ? Center(
                  child: CircularProgressIndicator(color: OColor.green500),
                )
                : _p.userClubs.isEmpty
                ? _buildNoAccessState()
                : RefreshIndicator(
                  color: OColor.green500,
                  onRefresh: _p.fetchEvents,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeader()),
                      SliverToBoxAdapter(child: _buildClubSelector()),
                      SliverToBoxAdapter(child: _buildTabBar()),
                      SliverToBoxAdapter(child: _buildAddEventButton()),
                      SliverToBoxAdapter(child: _buildYourEventsHeader()),
                      _buildEventsList(),
                    ],
                  ),
                ),
      ),
    );
  }

  /// "No admin access" empty state
  Widget _buildNoAccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(OSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FluentIcons.lock_closed_24_regular,
              size: 64,
              color: OColor.gray400,
            ),
            const SizedBox(height: OSpacing.m),
            OText(
              text: 'No Admin Access',
              style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
            ),
            const SizedBox(height: OSpacing.xs),
            OText(
              text: 'You don\'t have admin rights for any clubs.',
              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Header: "Manage" title + "Admin Rights" badge + profile icon
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OSpacing.m,
        OSpacing.m,
        OSpacing.m,
        OSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OText(
                  text: 'Events',
                  style: OTextStyle.headingLarge.copyWith(
                    color: OColor.gray800,
                  ),
                ),
                const SizedBox(width: OSpacing.m),
                Flexible(
                  child: OText(
                    text: 'Admin Rights',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OTextStyle.headingSmall.copyWith(
                      color: OColor.green600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Profile action placeholder
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: OColor.gray300),
              ),
              child: Icon(
                FluentIcons.person_24_regular,
                size: 20,
                color: OColor.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Club selector dropdown
  Widget _buildClubSelector() {
    if (_p.selectedClub == null) return const SizedBox.shrink();

    // Build initials from club name
    final words = _p.selectedClub!.name.split(' ');
    final initials =
        words.length >= 2
            ? '${words[0][0]}${words[1][0]}'.toUpperCase()
            : _p.selectedClub!.name.substring(0, 2).toUpperCase();

    // Build sub-label from clubsOrgs
    final subLabel =
        _p.selectedClub!.board.isNotEmpty
            ? _p.selectedClub!.board
            : _p.selectedClub!.description;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OSpacing.m,
        vertical: OSpacing.xs,
      ),
      child: GestureDetector(
        onTap: _p.userClubs.length > 1 ? () => _showClubPicker() : null,
        child: Container(
          padding: const EdgeInsets.all(OSpacing.s),
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: BorderRadius.circular(OCornerRadius.m),
            border: Border.all(color: OColor.gray200),
          ),
          child: Row(
            children: [
              // Initials avatar
              Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: OColor.gray100,
                  borderRadius: BorderRadius.circular(OCornerRadius.s),
                ),
                child:
                    _p.selectedClub!.logo.isNotEmpty
                        ? Image.network(
                          _p.selectedClub!.logo,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stack) =>
                                  _initialsText(initials),
                        )
                        : _initialsText(initials),
              ),
              const SizedBox(width: OSpacing.s),
              // Club name and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OText(
                      text: _p.selectedClub!.name,
                      style: OTextStyle.headingXSmall.copyWith(
                        color: OColor.gray800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    OText(
                      text: subLabel,
                      style: OTextStyle.bodyXSmall.copyWith(
                        color: OColor.gray500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Settings / dropdown icon
              Icon(
                _p.userClubs.length > 1
                    ? FluentIcons.chevron_down_16_regular
                    : FluentIcons.settings_16_regular,
                size: 20,
                color: OColor.gray500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _initialsText(String initials) {
    return Center(
      child: OText(
        text: initials,
        style: OTextStyle.labelSmall.copyWith(
          color: OColor.gray600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showClubPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            decoration: BoxDecoration(
              color: OColor.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(OSpacing.m),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: OColor.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: OSpacing.m),
                OText(
                  text: 'Select Club',
                  style: OTextStyle.headingSmall.copyWith(
                    color: OColor.gray800,
                  ),
                ),
                const SizedBox(height: OSpacing.s),
                ..._p.userClubs.map(
                  (club) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            club.name == _p.selectedClub?.name
                                ? OColor.green100
                                : OColor.gray100,
                        borderRadius: BorderRadius.circular(OCornerRadius.s),
                      ),
                      child: Center(
                        child: OText(
                          text:
                              club.name.split(' ').length >= 2
                                  ? '${club.name.split(' ')[0][0]}${club.name.split(' ')[1][0]}'
                                      .toUpperCase()
                                  : club.name.substring(0, 2).toUpperCase(),
                          style: OTextStyle.labelSmall.copyWith(
                            color:
                                club.name == _p.selectedClub?.name
                                    ? OColor.green600
                                    : OColor.gray600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    title: OText(
                      text: club.name,
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.gray800,
                      ),
                    ),
                    trailing:
                        club.name == _p.selectedClub?.name
                            ? Icon(
                              FluentIcons.checkmark_16_regular,
                              color: OColor.green600,
                            )
                            : null,
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _p.selectClub(club);
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + OSpacing.s,
                ),
              ],
            ),
          ),
    );
  }

  void _openPage(Widget page) {
    final provider = _p;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider.value(value: provider, child: page),
      ),
    );
  }

  /// Shortcuts to the "Past Events" and "Drafts" pages
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
      child: tb.ToggleButtons(
        label1: 'Past Events',
        label2: 'Drafts',
        icon1: TablerIcons.history,
        icon2: TablerIcons.file,
        onTapTile1: () {
          _openPage(const PastEventsPage());
        },
        onTapTile2: () {
          _openPage(const DraftsPage());
        },
      ),
    );
  }

  /// "+ Add Event" primary button
  Widget _buildAddEventButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OSpacing.m,
        vertical: OSpacing.xs,
      ),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          label: 'Add Event',
          onPressed: _onAddEvent,
          leadingIcon: TablerIcons.plus,
        ),
      ),
    );
  }

  /// "Your Events" section header
  Widget _buildYourEventsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OSpacing.m,
        OSpacing.s,
        OSpacing.m,
        OSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(FluentIcons.person_24_regular, size: 24, color: OColor.gray800),
          const SizedBox(width: OSpacing.xs),
          OText(
            text: 'Your Events',
            style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
          ),
        ],
      ),
    );
  }

  /// Events list or loading/empty state
  Widget _buildEventsList() {
    if (_p.isLoadingEvents) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(OSpacing.xl),
            child: CircularProgressIndicator(color: OColor.green500),
          ),
        ),
      );
    }

    if (_p.postedEvents.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(OSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FluentIcons.calendar_empty_24_regular,
                  size: 48,
                  color: OColor.gray400,
                ),
                const SizedBox(height: OSpacing.s),
                OText(
                  text: 'No posted events',
                  style: OTextStyle.headingSmall.copyWith(
                    color: OColor.gray600,
                  ),
                ),
                const SizedBox(height: OSpacing.xxs),
                OText(
                  text: 'Events you post will appear here.',
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: OSpacing.m),
            child: AdminEventCard(
              event: _p.postedEvents[index],
              onEdit: () => _onEditEvent(_p.postedEvents[index]),
              onDelete: () => _onDeleteEvent(_p.postedEvents[index]),
            ),
          ),
          childCount: _p.postedEvents.length,
        ),
      ),
    );
  }
}
