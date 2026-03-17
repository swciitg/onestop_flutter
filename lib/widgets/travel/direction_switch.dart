import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class DirectionSwitch extends StatelessWidget {
  final bool fromCampus;
  final String leftLabel;
  final String rightLabel;
  final String leftSub;
  final String rightSub;
  final VoidCallback onSwap;

  const DirectionSwitch({
    super.key,
    required this.fromCampus,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftSub,
    required this.rightSub,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final from = fromCampus ? rightLabel : leftLabel;
    final to = fromCampus ? leftLabel : rightLabel;
    final fromSub = fromCampus ? rightSub : leftSub;
    final toSub = fromCampus ? leftSub : rightSub;
    final fromIsIIT = from == 'IIT';
    final toIsIIT = to == 'IIT';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // From location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: fromIsIIT ? const Color(0xFF6C63AC) : OColor.green600,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        fromIsIIT
                            ? FluentIcons.hat_graduation_24_regular
                            : FluentIcons.building_24_regular,
                        size: 16,
                        color: OColor.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(from, style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  fromSub.toUpperCase(),
                  style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          // Connecting line + Swap button + arrow line
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container(height: 1.5, color: OColor.gray500)),
                GestureDetector(
                  onTap: onSwap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: OColor.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: OColor.gray200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.arrow_swap_24_regular, size: 18, color: OColor.green600),
                        const SizedBox(width: 4),
                        Text('Swap', style: OTextStyle.labelSmall.copyWith(color: OColor.gray800)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(height: 1.5, color: OColor.gray500),
                      Icon(FluentIcons.chevron_right_24_regular, size: 14, color: OColor.gray400),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // To location
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: toIsIIT ? const Color(0xFF6C63AC) : OColor.green600,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        toIsIIT
                            ? FluentIcons.hat_graduation_24_regular
                            : FluentIcons.building_24_regular,
                        size: 16,
                        color: OColor.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(to, style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  toSub.toUpperCase(),
                  style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
