import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_avatar_stack.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_going_button.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Large event card used in the "Your Interests" and "Explore" sections.
///
/// Composed of [EventNetworkImage], [OTag], [EventAvatarStack], and [EventGoingButton].
class EventListingLargeCard extends StatelessWidget {
  final EventModel event;
  final int interestedCount;
  final bool isGoing;
  final VoidCallback? onTap;
  final VoidCallback? onGoingTap;

  const EventListingLargeCard({
    super.key,
    required this.event,
    this.interestedCount = 0,
    this.isGoing = false,
    this.onTap,
    this.onGoingTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = event.compressedImageUrl ?? event.imageUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OSpacing.s),
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
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image preview with progressive shimmer & caching
                EventNetworkImage.banner(
                  imageUrl: imageUrl,
                  aspectRatio: 358 / 201,
                  borderRadius: BorderRadius.circular(OCornerRadius.s),
                ),
                const SizedBox(height: OSpacing.s),
                // Title row with chevron
                _buildTitleRow(),
                const SizedBox(height: OSpacing.s),
                // Tags using OTag from onestop_ui
                _buildTags(),
                const SizedBox(height: OSpacing.s),
                // Location and date
                _buildLocationAndDate(),
                const SizedBox(height: OSpacing.s),
                // Organizer profile
                _buildOrganizerProfile(),
              ],
            ),
          ),
          const SizedBox(height: OSpacing.s),
          // Divider
          Divider(height: 1, color: OColor.gray200),
          const SizedBox(height: OSpacing.s),
          // Footer: avatar group + interested count + Going button
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: OText(
            text: EventFormatters.sanitizeText(event.title),
            style: OTextStyle.headingSmall.copyWith(
              color: OColor.gray800,
            ),
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

  Widget _buildTags() {
    final validTags = event.categories.where((c) => c.trim().isNotEmpty).toList();
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

  Widget _buildLocationAndDate() {
    final dateRange = EventFormatters.formatLargeCardDate(event.startDateTime, event.endDateTime);
    final venue = EventFormatters.sanitizeVenue(event.venue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        Row(
          children: [
            Icon(FluentIcons.location_16_regular, size: 16, color: OColor.gray600),
            const SizedBox(width: OSpacing.xxs),
            Expanded(
              child: OText(
                text: venue,
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: OSpacing.xxs),
        // Date
        Row(
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
        ),
      ],
    );
  }

  Widget _buildOrganizerProfile() {
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

  Widget _buildFooter() {
    final safeCount = interestedCount > 0 ? interestedCount : 0;
    final compactCount = EventFormatters.formatCount(safeCount);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar stack + interested count
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const EventAvatarStack(count: 3, size: 24, overlap: 20),
              if (safeCount > 0) ...[
                const SizedBox(width: OSpacing.xxs),
                Flexible(
                  child: OText(
                    text: '$compactCount INTERESTED',
                    style: OTextStyle.labelSmall.copyWith(color: OColor.blue500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: OSpacing.xs),
        // Isolated I'm Going button
        EventGoingButton(
          isGoing: isGoing,
          onTap: onGoingTap,
        ),
      ],
    );
  }
}
