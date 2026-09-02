import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Small horizontal event card used in the "Happening Today" section.
///
/// Composed of [EventNetworkImage.avatar], title, venue, and trailing chevron.
class EventListingSmallCard extends StatelessWidget {
  final EventModel event;
  final bool isGoing;
  final VoidCallback? onTap;

  const EventListingSmallCard({
    super.key,
    required this.event,
    this.isGoing = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = EventFormatters.sanitizeText(event.title);
    final venue = EventFormatters.sanitizeVenue(event.venue);
    final imageUrl = event.compressedImageUrl ?? event.imageUrl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 358,
        padding: const EdgeInsets.all(OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            // Avatar with progressive shimmer & caching
            EventNetworkImage.avatar(
              imageUrl: imageUrl,
              width: 48,
              height: 48,
            ),
            const SizedBox(width: OSpacing.s),
            // Content
            Expanded(
              child: ClipRect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Event name
                    OText(
                      text: title,
                      style: OTextStyle.bodyMedium.copyWith(
                        color: OColor.gray800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isGoing) ...[
                      const SizedBox(height: OSpacing.xxs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FluentIcons.checkmark_16_filled,
                            size: 16,
                            color: OColor.green600,
                          ),
                          const SizedBox(width: OSpacing.xxs),
                          OText(
                            text: "I'M GOING",
                            style: OTextStyle.labelSmall.copyWith(
                              color: OColor.green600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: OSpacing.xxs),
                    // Time and location
                    OText(
                      text: venue,
                      style: OTextStyle.bodySmall.copyWith(
                        color: OColor.gray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: OSpacing.xs),
            // Chevron
            Icon(
              FluentIcons.chevron_right_24_regular,
              size: 24,
              color: OColor.gray600,
            ),
          ],
        ),
      ),
    );
  }
}
