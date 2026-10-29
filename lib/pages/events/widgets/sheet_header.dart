import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Shared modal header: leading icon, title and a round close button.
class SheetHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SheetHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 32, color: OColor.green600),
        const SizedBox(width: OSpacing.m),
        Expanded(
          child: OText(
            text: title,
            style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(OSpacing.xs),
            decoration: BoxDecoration(
              color: OColor.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              FluentIcons.dismiss_24_regular,
              size: 24,
              color: OColor.gray800,
            ),
          ),
        ),
      ],
    );
  }
}
