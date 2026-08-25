import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_ui/index.dart';

/// Large event card used in the "Your Interests" and "Explore" sections.
///
/// Shows image, title with chevron, tags, location, date, organizer profile,
/// divider, avatar group + interested count, and "I'm Going" button.
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Image preview
            _buildImagePreview(),
            const SizedBox(height: OSpacing.s),
            // Title row with chevron
            _buildTitleRow(),
            const SizedBox(height: OSpacing.s),
            // Tags
            _buildTags(),
            const SizedBox(height: OSpacing.s),
            // Location and date
            _buildLocationAndDate(),
            const SizedBox(height: OSpacing.s),
            // Organizer profile
            _buildOrganizerProfile(),
            const SizedBox(height: OSpacing.s),
            // Divider
            Divider(height: 1, color: OColor.gray200),
            const SizedBox(height: OSpacing.s),
            // Footer: avatar group + interested count + Going button
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final imageUrl = event.compressedImageUrl ?? event.imageUrl;
    if (imageUrl != null) {
      return AspectRatio(
        aspectRatio: 358 / 201,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(OCornerRadius.s),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _imagePlaceholder(),
          ),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 358 / 201,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        child: _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: OColor.gray200,
      child: Center(
        child: Icon(
          FluentIcons.image_24_regular,
          size: 48,
          color: OColor.gray400,
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Expanded(
          child: OText(
            text: event.title,
            style: OTextStyle.headingSmall.copyWith(
              color: OColor.gray800,
            ),
            maxLines: 2,
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
    if (event.categories.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: OSpacing.m,
      runSpacing: OSpacing.xs,
      children: event.categories.take(2).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final color = index == 0 ? OColor.blue600 : OColor.green600;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: OColor.gray100,
            borderRadius: BorderRadius.circular(OCornerRadius.l),
          ),
          child: OText(
            text: category.toUpperCase(),
            style: OTextStyle.labelSmall.copyWith(color: color),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationAndDate() {
    final dateFormat = DateFormat("dd MMM, h:mm a");
    final timeFormat = DateFormat("h:mm a");

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
                text: event.venue,
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
                text:
                    '${dateFormat.format(event.startDateTime)} - ${timeFormat.format(event.endDateTime)}',
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
            text: event.clubOrg,
            style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar group + interested count
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatarGroup(),
            const SizedBox(width: OSpacing.xxs),
            if (interestedCount > 0)
              OText(
                text: '$interestedCount INTERESTED',
                style: OTextStyle.labelSmall.copyWith(color: OColor.blue500),
              ),
          ],
        ),
        // I'm Going button
        GestureDetector(
          onTap: onGoingTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: OSpacing.m,
              vertical: OSpacing.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(OCornerRadius.m),
              border: Border.all(color: OColor.gray300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isGoing
                      ? FluentIcons.heart_16_filled
                      : FluentIcons.heart_16_regular,
                  size: 16,
                  color: OColor.green600,
                ),
                const SizedBox(width: OSpacing.xxs),
                OText(
                  text: "I'm Going",
                  style: OTextStyle.labelMedium.copyWith(
                    color: OColor.green600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarGroup() {
    return SizedBox(
      width: 64,
      height: 24,
      child: Stack(
        children: List.generate(3, (index) {
          return Positioned(
            left: index * 20.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: OColor.gray300,
                shape: BoxShape.circle,
                border: Border.all(color: OColor.white, width: 2),
              ),
              child: Icon(
                FluentIcons.person_12_regular,
                size: 12,
                color: OColor.gray600,
              ),
            ),
          );
        }),
      ),
    );
  }
}
