import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class HomeFoodTile extends StatelessWidget {
  final VoidCallback moveToFoodMenu;
  const HomeFoodTile({super.key, required this.moveToFoodMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: OColor.gray300.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: OColor.green100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(FluentIcons.food_24_regular, color: OColor.green600, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OText(
                  text: 'Food',
                  style: OTextStyle.headingSmall.copyWith(
                    color: OColor.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(16, 0),
                child: IconButton(
                  onPressed: moveToFoodMenu,
                  icon: Icon(FluentIcons.chevron_right_24_regular, color: OColor.gray400, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OText(
            text: 'LUNCH • ENDS 2:15 PM',
            style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OText(
                text: 'Rajma',
                style: OTextStyle.bodyMedium.copyWith(
                  color: OColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              OText(
                text: 'Chilli Soyabean',
                style: OTextStyle.bodyMedium.copyWith(
                  color: OColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              OText(
                text: 'Seviya',
                style: OTextStyle.bodyMedium.copyWith(
                  color: OColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
