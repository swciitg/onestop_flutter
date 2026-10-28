import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Compact card for a draft event: avatar, title, "time, venue" sub-text,
/// tags, a "Saved … ago" label and a chevron.
class EventsDraftCard extends StatelessWidget {
  static final DateFormat _timeFormat = DateFormat('h:mm a');

  final EventModel event;
  final VoidCallback? onTap;

  const EventsDraftCard({super.key, required this.event, this.onTap});

  static String _savedAgo(DateTime? savedAt) {
    if (savedAt == null) return 'Saved';
    final diff = DateTime.now().difference(savedAt);
    if (diff.inMinutes < 1) return 'Saved just now';
    if (diff.inMinutes < 60) return 'Saved ${diff.inMinutes} mins ago';
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return 'Saved $h ${h == 1 ? 'hour' : 'hours'} ago';
    }
    final d = diff.inDays;
    return 'Saved $d ${d == 1 ? 'day' : 'days'} ago';
  }

  @override
  Widget build(BuildContext context) {
    final subText =
        '${_timeFormat.format(event.startDateTime)}, '
        '${EventFormatters.sanitizeVenue(event.venue)}';
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventNetworkImage.avatar(
              imageUrl: event.compressedImageUrl ?? event.imageUrl,
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
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
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
                  const SizedBox(height: OSpacing.m),
                  Row(
                    children: [
                      Icon(
                        FluentIcons.document_16_regular,
                        size: 16,
                        color: OColor.green600,
                      ),
                      const SizedBox(width: OSpacing.xs),
                      Flexible(
                        child: OText(
                          text:
                              _savedAgo(
                                event.updatedAt ?? event.createdAt,
                              ).toUpperCase(),
                          style: OTextStyle.labelXSmall.copyWith(
                            color: OColor.green600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: OSpacing.xs),
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
