import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_ui/index.dart';

/// Medium event card used in the "Trending Events" horizontal scroll.
///
/// Shows an image preview, event title, date/time, location,
/// avatar group, and "+N Going" count.
class EventListingMediumCard extends StatelessWidget {
  final EventModel event;
  final int goingCount;
  final VoidCallback? onTap;

  const EventListingMediumCard({
    super.key,
    required this.event,
    this.goingCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210,
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
            // Content
            Padding(
              padding: const EdgeInsets.all(OSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SizedBox(
                    height: 40,
                    child: OText(
                      text: event.title,
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.gray800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: OSpacing.xs),
                  // Date/time
                  OText(
                    text: _formatDateTime(),
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: OSpacing.xxs),
                  // Location
                  OText(
                    text: event.venue,
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: OSpacing.xs),
                  // Avatar group + going count
                  Row(
                    children: [
                      _buildAvatarGroup(),
                      const SizedBox(width: OSpacing.xxs),
                      if (goingCount > 0)
                        OText(
                          text: '+$goingCount GOING',
                          style: OTextStyle.labelSmall.copyWith(
                            color: OColor.blue500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(OCornerRadius.s),
            topRight: Radius.circular(OCornerRadius.s),
          ),
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
      child: _imagePlaceholder(),
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

  String _formatDateTime() {
    final dateFormat = DateFormat('dd MMM');
    final timeFormat = DateFormat('h:mm a');
    return '${dateFormat.format(event.startDateTime)}, '
        '${timeFormat.format(event.startDateTime)} - '
        '${timeFormat.format(event.endDateTime)}';
  }
}
