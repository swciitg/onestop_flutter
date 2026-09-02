import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Reusable overlapping avatar stack for attendee previews.
class EventAvatarStack extends StatelessWidget {
  final int count;
  final double size;
  final double overlap;

  const EventAvatarStack({
    super.key,
    this.count = 3,
    this.size = 24.0,
    this.overlap = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final totalWidth = size + (count - 1) * overlap;

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: List.generate(count, (index) {
          return Positioned(
            left: index * overlap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: OColor.gray300,
                shape: BoxShape.circle,
                border: Border.all(color: OColor.white, width: 2),
              ),
              child: Icon(
                FluentIcons.person_12_regular,
                size: size * 0.5,
                color: OColor.gray600,
              ),
            ),
          );
        }),
      ),
    );
  }
}
