import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Isolated interactive "I'm Going" button wrapped in [RepaintBoundary].
class EventGoingButton extends StatelessWidget {
  final bool isGoing;
  final VoidCallback? onTap;

  const EventGoingButton({
    super.key,
    required this.isGoing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: OSpacing.m,
            vertical: OSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isGoing ? OColor.green100 : Colors.transparent,
            borderRadius: BorderRadius.circular(OCornerRadius.m),
            border: Border.all(
              color: isGoing ? OColor.green600 : OColor.gray300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isGoing
                    ? FluentIcons.checkmark_16_filled
                    : FluentIcons.heart_16_regular,
                size: 16,
                color: OColor.green600,
              ),
              const SizedBox(width: OSpacing.xxs),
              OText(
                text: isGoing ? "Going" : "I'm Going",
                style: OTextStyle.labelMedium.copyWith(
                  color: OColor.green600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
