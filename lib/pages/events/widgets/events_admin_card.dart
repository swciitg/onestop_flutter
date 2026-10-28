import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Event card for the admin screens: banner, stats row, title, tags, venue,
/// date and organizer. The Edit / Delete footer only shows when [onEdit] or
/// [onDelete] is provided (past events are read-only).
class AdminEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminEventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasActions = onEdit != null || onDelete != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
            if (hasActions) ...[
              Divider(height: 1, color: OColor.gray200),
              _buildActions(),
            ],
          ],
        ),
      ),
    );
  }

  /// Stats: comments, views, registrants
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statChip(
          FluentIcons.heart_16_regular,
          EventFormatters.formatCount(event.likes),
        ),
        const SizedBox(width: OSpacing.s),
        _statChip(
          FluentIcons.people_16_regular,
          EventFormatters.formatCount(event.registrants),
        ),
        const SizedBox(width: OSpacing.s),
        _statChip(
          FluentIcons.chat_16_regular,
          EventFormatters.formatCount(event.feedback.length),
        ),
      ],
    );
  }

  Widget _statChip(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: OColor.blue500),
        const SizedBox(width: 4),
        OText(
          text: count,
          style: OTextStyle.labelXSmall.copyWith(color: OColor.blue500),
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
      children:
          validTags.take(2).toList().asMap().entries.map((entry) {
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
