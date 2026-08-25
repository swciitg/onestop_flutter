import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_ui/index.dart';

/// Compact event card used in the "Recently Attended" horizontal scroll.
///
/// Shows avatar, event title, optional tags, and an optional
/// "Submit a Feedback" button with a trailing chevron.
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
                // Avatar
                _buildAvatar(),
                const SizedBox(width: OSpacing.s),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      OText(
                        text: event.title,
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
              const SizedBox(height: OSpacing.l),
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
                    child: Container(
                      width: double.infinity,
                      height: 48,
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

  Widget _buildAvatar() {
    if (event.compressedImageUrl != null) {
      return ClipOval(
        child: Image.network(
          event.compressedImageUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderAvatar(),
        ),
      );
    }
    return _placeholderAvatar();
  }

  Widget _placeholderAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: OColor.gray200,
        shape: BoxShape.circle,
      ),
      child: Icon(
        FluentIcons.calendar_24_regular,
        size: 24,
        color: OColor.gray600,
      ),
    );
  }
}
