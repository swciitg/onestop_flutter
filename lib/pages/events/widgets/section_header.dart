import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// A reusable section header with an icon, title, and optional trailing action.
///
/// Used across the Events homepage for sections like "Happening Today",
/// "Trending Events", "Your Interests", "Recently Attended", and "Explore".
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.actionLabel,
    this.actionIcon,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: OColor.gray800),
            const SizedBox(width: OSpacing.xs),
            OText(
              text: title,
              style: OTextStyle.headingSmall.copyWith(
                color: OColor.gray800,
              ),
            ),
          ],
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: OSpacing.m,
                vertical: OSpacing.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actionIcon != null) ...[
                    Icon(actionIcon, size: 16, color: OColor.green600),
                    const SizedBox(width: 6),
                  ],
                  OText(
                    text: actionLabel!,
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
}
