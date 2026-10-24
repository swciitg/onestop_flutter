import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_dev/pages/events/providers/events_admin_provider.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

import 'create_edit_event_page.dart';

/// The admin "Manage" page for the Events section.
///
/// Allows admins to view their club's events (Past Events / Drafts),
/// create new events, and edit or delete existing ones.
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreateEditEventPage(),
      ),
    );
  }

  void _onEditEvent(EventModel event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateEditEventPage(event: event),
      ),
    );
  }

  Future<void> _onDeleteEvent(EventModel event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
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
        child: _p.isLoading
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
      padding: const EdgeInsets.fromLTRB(OSpacing.m, OSpacing.m, OSpacing.m, OSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OText(
            text: 'Manage',
            style: OTextStyle.headingLarge.copyWith(color: OColor.gray800),
          ),
          const SizedBox(width: OSpacing.xs),
          OTag(
            type: TagType.accentColor,
            label: 'Admin Rights',
            lead: FluentIcons.shield_checkmark_16_regular,
          ),
          const Spacer(),
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
    final initials = words.length >= 2
        ? '${words[0][0]}${words[1][0]}'.toUpperCase()
        : _p.selectedClub!.name.substring(0, 2).toUpperCase();

    // Build sub-label from clubsOrgs
    final subOrgs = _p.selectedClub!.members.clubsOrgs;
    final subLabel = subOrgs.isNotEmpty
        ? 'Club, ${_p.selectedClub!.name}'
        : _p.selectedClub!.name;

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
                decoration: BoxDecoration(
                  color: OColor.gray100,
                  borderRadius: BorderRadius.circular(OCornerRadius.s),
                ),
                child: Center(
                  child: OText(
                    text: initials,
                    style: OTextStyle.labelSmall.copyWith(
                      color: OColor.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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

  void _showClubPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
            ),
            const SizedBox(height: OSpacing.s),
            ..._p.userClubs.map((club) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: club.name == _p.selectedClub?.name
                          ? OColor.green100
                          : OColor.gray100,
                      borderRadius: BorderRadius.circular(OCornerRadius.s),
                    ),
                    child: Center(
                      child: OText(
                        text: club.name.split(' ').length >= 2
                            ? '${club.name.split(' ')[0][0]}${club.name.split(' ')[1][0]}'
                                .toUpperCase()
                            : club.name.substring(0, 2).toUpperCase(),
                        style: OTextStyle.labelSmall.copyWith(
                          color: club.name == _p.selectedClub?.name
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
                  trailing: club.name == _p.selectedClub?.name
                      ? Icon(FluentIcons.checkmark_16_regular,
                          color: OColor.green600)
                      : null,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _p.selectClub(club);
                  },
                )),
            SizedBox(height: MediaQuery.of(context).padding.bottom + OSpacing.s),
          ],
        ),
      ),
    );
  }

  /// Tab bar: "Past Events" and "Drafts"
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OSpacing.m,
        vertical: OSpacing.xs,
      ),
      child: Row(
        children: [
          _buildTab(
            icon: FluentIcons.clock_16_regular,
            label: 'Past Events',
            index: 0,
          ),
          const SizedBox(width: OSpacing.s),
          _buildTab(
            icon: FluentIcons.document_16_regular,
            label: 'Drafts',
            index: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _p.selectedTabIndex == index;

    return GestureDetector(
      onTap: () => _p.selectTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: OSpacing.m,
          vertical: OSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? OColor.green100 : Colors.transparent,
          borderRadius: BorderRadius.circular(OCornerRadius.xl),
          border: Border.all(
            color: isSelected ? OColor.green500 : OColor.gray300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? OColor.green600 : OColor.gray600,
            ),
            const SizedBox(width: OSpacing.xxs),
            OText(
              text: label,
              style: OTextStyle.labelSmall.copyWith(
                color: isSelected ? OColor.green600 : OColor.gray600,
              ),
            ),
          ],
        ),
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
          label: '+ Add Event',
          onPressed: _onAddEvent,
          leadingIcon: FluentIcons.add_16_regular,
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

    if (_p.events.isEmpty) {
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
                  text: _p.selectedTabIndex == 0
                      ? 'No past events'
                      : 'No drafts yet',
                  style:
                      OTextStyle.headingSmall.copyWith(color: OColor.gray600),
                ),
                const SizedBox(height: OSpacing.xxs),
                OText(
                  text: _p.selectedTabIndex == 0
                      ? 'Your completed events will appear here.'
                      : 'Create a draft to get started.',
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
            child: _AdminEventCard(
              event: _p.events[index],
              onEdit: () => _onEditEvent(_p.events[index]),
              onDelete: () => _onDeleteEvent(_p.events[index]),
            ),
          ),
          childCount: _p.events.length,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Admin Event Card
// ---------------------------------------------------------------------------

/// An event card for the admin "Manage" screen, matching the Figma design.
///
/// Shows: banner image, stats row, title, tags, location, date, organizer,
/// and Edit / Delete action buttons.
class _AdminEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _AdminEventCard({
    required this.event,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(OSpacing.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Banner image
                EventNetworkImage.banner(
                  imageUrl: event.compressedImageUrl ?? event.imageUrl,
                  aspectRatio: 358 / 201,
                  borderRadius: BorderRadius.circular(OCornerRadius.s),
                ),
                const SizedBox(height: OSpacing.s),
                // Stats row
                _buildStatsRow(),
                const SizedBox(height: OSpacing.s),
                // Title with chevron
                _buildTitleRow(),
                const SizedBox(height: OSpacing.s),
                // Tags
                _buildTags(),
                const SizedBox(height: OSpacing.s),
                // Location
                _buildLocationRow(),
                const SizedBox(height: OSpacing.xxs),
                // Date
                _buildDateRow(),
                const SizedBox(height: OSpacing.s),
                // Organizer
                _buildOrganizerRow(),
              ],
            ),
          ),
          // Divider + actions
          Divider(height: 1, color: OColor.gray200),
          _buildActions(),
        ],
      ),
    );
  }

  /// Stats: comments, views, registrants
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statChip(FluentIcons.chat_16_regular, EventFormatters.formatCount(event.feedback.length)),
        const SizedBox(width: OSpacing.s),
        _statChip(FluentIcons.eye_16_regular, EventFormatters.formatCount(event.likes)),
        const SizedBox(width: OSpacing.s),
        _statChip(FluentIcons.people_16_regular, EventFormatters.formatCount(event.registrants)),
      ],
    );
  }

  Widget _statChip(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: OColor.gray500),
        const SizedBox(width: 4),
        OText(
          text: count,
          style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600),
        ),
      ],
    );
  }

  /// Title + chevron
  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: OText(
            text: EventFormatters.sanitizeText(event.title),
            style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: OSpacing.m),
        Icon(
          FluentIcons.chevron_right_24_regular,
          size: 24,
          color: OColor.gray600,
        ),
      ],
    );
  }

  /// Tags (up to 2)
  Widget _buildTags() {
    final validTags =
        event.categories.where((c) => c.trim().isNotEmpty).toList();
    if (validTags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: OSpacing.s,
      runSpacing: OSpacing.xs,
      children: validTags.take(2).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value.trim();
        return OTag(
          type: index == 0 ? TagType.accentColor : TagType.neutral,
          label: category.toUpperCase(),
        );
      }).toList(),
    );
  }

  /// Location row
  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(FluentIcons.location_16_regular, size: 16, color: OColor.gray600),
        const SizedBox(width: OSpacing.xxs),
        Expanded(
          child: OText(
            text: EventFormatters.sanitizeVenue(event.venue),
            style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Date row
  Widget _buildDateRow() {
    final dateRange = EventFormatters.formatLargeCardDate(
      event.startDateTime,
      event.endDateTime,
    );

    return Row(
      children: [
        Icon(FluentIcons.calendar_16_regular, size: 16, color: OColor.gray600),
        const SizedBox(width: OSpacing.xxs),
        Expanded(
          child: OText(
            text: dateRange,
            style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Organizer row
  Widget _buildOrganizerRow() {
    final clubName = EventFormatters.sanitizeClub(event.clubOrg);

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: OColor.gray300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            FluentIcons.people_16_regular,
            size: 14,
            color: OColor.gray600,
          ),
        ),
        const SizedBox(width: OSpacing.xs),
        Expanded(
          child: OText(
            text: clubName,
            style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Edit / Delete action buttons
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OSpacing.s,
        vertical: OSpacing.s,
      ),
      child: Row(
        children: [
          // Edit button
          Expanded(
            child: GestureDetector(
              onTap: onEdit,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.edit_16_regular,
                    size: 16,
                    color: OColor.green600,
                  ),
                  const SizedBox(width: OSpacing.xxs),
                  OText(
                    text: 'Edit',
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.green600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Delete button
          Expanded(
            child: GestureDetector(
              onTap: onDelete,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.delete_16_regular,
                    size: 16,
                    color: OColor.red500,
                  ),
                  const SizedBox(width: OSpacing.xxs),
                  OText(
                    text: 'Delete',
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.red500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
