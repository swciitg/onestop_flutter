import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Card for an attended event: avatar, title, time & venue, tags and either a
/// "Submit a Feedback" button or the user's submitted feedback.
class EventsAttendedCard extends StatelessWidget {
  final EventModel event;

  /// The user's submitted feedback text. When non-null the card shows
  /// "Your Feedback" instead of the submit button.
  final String? submittedFeedback;
  final VoidCallback? onTap;
  final VoidCallback? onFeedbackTap;

  const EventsAttendedCard({
    super.key,
    required this.event,
    this.submittedFeedback,
    this.onTap,
    this.onFeedbackTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = event.compressedImageUrl ?? event.imageUrl;
    final venue = EventFormatters.sanitizeVenue(event.venue);
    final subText =
        '${DateFormat('h:mm a').format(event.startDateTime)}, $venue';
    final tags = event.categories.where((c) => c.trim().isNotEmpty).take(2);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventNetworkImage.avatar(
                  imageUrl: imageUrl,
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: OSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OText(
                        text: EventFormatters.sanitizeText(event.title),
                        style: OTextStyle.bodyMedium.copyWith(
                          color: OColor.gray800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: OSpacing.xxs),
                      OText(
                        text: subText,
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: OSpacing.xs),
                        Wrap(
                          spacing: OSpacing.s,
                          runSpacing: OSpacing.xs,
                          children: [
                            for (final entry in tags.toList().asMap().entries)
                              OTag(
                                type:
                                    entry.key == 0
                                        ? TagType.accentColor
                                        : TagType.neutral,
                                label: entry.value.trim().toUpperCase(),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: OSpacing.xs),
                Icon(
                  FluentIcons.chevron_right_24_regular,
                  size: 24,
                  color: OColor.gray800,
                ),
              ],
            ),
            const SizedBox(height: OSpacing.l),
            if (submittedFeedback != null)
              _buildSubmittedFeedback(submittedFeedback!)
            else
              _buildFeedbackPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackPrompt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: 'ENJOYED THE EVENT?',
          style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.xs),
        GestureDetector(
          onTap: onFeedbackTap,
          behavior: HitTestBehavior.opaque,
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
    );
  }

  Widget _buildSubmittedFeedback(String feedback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 1, color: OColor.gray200),
        const SizedBox(height: OSpacing.xs),
        OText(
          text: 'YOUR FEEDBACK',
          style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                FluentIcons.chat_24_regular,
                size: 16,
                color: OColor.green600,
              ),
            ),
            const SizedBox(width: OSpacing.xs),
            Expanded(
              child: OText(
                text: '“$feedback”',
                style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
