import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Compact event card used in the "Recently Attended" horizontal scroll.
///
/// Composed of [EventNetworkImage.avatar], title, and "Submit a Feedback" button.
class EventsCompactCard extends StatelessWidget {
  final EventModel event;
  final bool showFeedbackButton;
  final VoidCallback? onTap;
  final VoidCallback? onFeedbackTap;

  const EventsCompactCard({
    super.key,
    required this.event,
    this.showFeedbackButton = true,
    this.onTap,
    this.onFeedbackTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = EventFormatters.sanitizeText(event.title);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: avatar + content + chevron
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      OText(
                        text: title,
                        style: OTextStyle.bodyMedium.copyWith(
                          color: OColor.gray800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
            // Feedback button
            if (showFeedbackButton) ...[
              const SizedBox(height: OSpacing.s),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OText(
                    text: 'ENJOYED THE EVENT?',
                    style: OTextStyle.labelSmall.copyWith(
                      color: OColor.gray800,
                    ),
                  ),
                  const SizedBox(height: OSpacing.xs),
                  GestureDetector(
                    onTap: onFeedbackTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(OCornerRadius.m),
                        border: Border.all(color: OColor.gray300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OText(
                            text: 'Submit a Feedback',
                            style: OTextStyle.labelMedium.copyWith(
                              color: OColor.green600,
                            ),
                          ),
                          const SizedBox(width: OSpacing.xxs),
                          Icon(
                            FluentIcons.chat_24_regular,
                            size: 16,
                            color: OColor.green600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
