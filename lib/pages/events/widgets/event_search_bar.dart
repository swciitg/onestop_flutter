import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Search bar widget matching the Figma design.
///
/// White rounded container with placeholder text and trailing search icon.
class EventSearchBar extends StatelessWidget {
  final String placeholder;
  final VoidCallback? onTap;

  const EventSearchBar({
    super.key,
    this.placeholder = 'Placeholder Text',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Expanded(
              child: OText(
                text: placeholder,
                style: OTextStyle.labelMedium.copyWith(
                  color: OColor.gray600,
                ),
              ),
            ),
            Icon(
              FluentIcons.search_24_regular,
              size: 24,
              color: OColor.gray600,
            ),
          ],
        ),
      ),
    );
  }
}
