import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_ui/index.dart';

/// Compact row card used on the "All Events" screen: avatar, title,
/// "time, venue" sub-text, tags and a chevron.
class EventsListCard extends StatelessWidget {
  static final DateFormat _timeFormat = DateFormat('h:mm a');

  final EventModel event;
  final VoidCallback? onTap;

  const EventsListCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = EventFormatters.sanitizeText(event.title);
    final subText =
        '${_timeFormat.format(event.startDateTime)}, '
        '${EventFormatters.sanitizeVenue(event.venue)}';
    final tags = event.tags.where((t) => t.trim().isNotEmpty).take(2).toList();

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
                    text: title,
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
                      spacing: OSpacing.xs,
                      runSpacing: OSpacing.xxs,
                      children: [
                        for (var i = 0; i < tags.length; i++)
                          OTag(
                            type: i == 0 ? TagType.accentColor : TagType.neutral,
                            label: tags[i].trim().toUpperCase(),
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
              color: OColor.gray600,
            ),
          ],
        ),
      ),
    );
  }
}
