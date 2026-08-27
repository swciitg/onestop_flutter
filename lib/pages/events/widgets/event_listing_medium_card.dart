import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_avatar_stack.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Medium event card used in the "Trending Events" horizontal scroll.
///
/// Composed of [EventNetworkImage] and [EventAvatarStack].
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
    final safeCount = goingCount > 0 ? goingCount : 0;
    final compactGoing = EventFormatters.formatCount(safeCount);
    final imageUrl = event.compressedImageUrl ?? event.imageUrl;

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
            // Image preview with progressive shimmer & caching
            EventNetworkImage.banner(
              imageUrl: imageUrl,
              aspectRatio: 16 / 9,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(OCornerRadius.s),
                topRight: Radius.circular(OCornerRadius.s),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(OSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 36),
                    child: OText(
                      text: EventFormatters.sanitizeText(event.title),
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
                    text: EventFormatters.formatDateTimeRange(
                      event.startDateTime,
                      event.endDateTime,
                    ),
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: OSpacing.xxs),
                  // Location
                  OText(
                    text: EventFormatters.sanitizeVenue(event.venue),
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: OSpacing.xs),
                  // Avatar stack + going count
                  Row(
                    children: [
                      const EventAvatarStack(count: 3, size: 24, overlap: 20),
                      if (safeCount > 0) ...[
                        const SizedBox(width: OSpacing.xxs),
                        Flexible(
                          child: OText(
                            text: '+$compactGoing GOING',
                            style: OTextStyle.labelSmall.copyWith(
                              color: OColor.blue500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
}
