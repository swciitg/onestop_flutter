import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Two side-by-side toggle tiles: "All Events" (with count badge) and "Saved Events".
///
/// Matches the Figma design's toggle tile row at the top of the Events homepage.
class EventToggleTiles extends StatelessWidget {
  final int allEventsCount;
  final VoidCallback? onAllEventsTap;
  final VoidCallback? onSavedEventsTap;

  const EventToggleTiles({
    super.key,
    this.allEventsCount = 0,
    this.onAllEventsTap,
    this.onSavedEventsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTile(
            icon: FluentIcons.list_24_regular,
            label: 'All Events',
            badgeCount: allEventsCount,
            onTap: onAllEventsTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTile(
            icon: FluentIcons.heart_24_regular,
            label: 'Saved Events',
            onTap: onSavedEventsTap,
          ),
        ),
      ],
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    int? badgeCount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: OColor.gray800),
            const SizedBox(width: OSpacing.xs),
            Flexible(
              child: OText(
                text: label,
                style: OTextStyle.labelLarge.copyWith(
                  color: OColor.gray800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (badgeCount != null && badgeCount > 0) ...[
              const SizedBox(width: OSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: OColor.blue100,
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                ),
                child: OText(
                  text: '$badgeCount',
                  style: OTextStyle.labelSmall.copyWith(
                    color: OColor.blue500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
