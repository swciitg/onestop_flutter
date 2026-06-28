import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class TimingTile extends StatelessWidget {
  final String time;
  final bool isLeft;
  final IconData icon;

  const TimingTile({super.key, required this.time, required this.isLeft, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OColor.green100,
              borderRadius: BorderRadius.circular(OCornerRadius.s),
            ),
            child: Icon(icon, color: OColor.green600, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: OTextStyle.labelMedium.copyWith(color: isLeft ? OColor.gray400 : OColor.gray800),
          ),
          const Spacer(),
          if (isLeft)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: OColor.gray100,
                borderRadius: BorderRadius.circular(OCornerRadius.xl),
              ),
              child: Text('LEFT', style: OTextStyle.labelXSmall.copyWith(color: OColor.gray400)),
            ),
        ],
      ),
    );
  }
}
