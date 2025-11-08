import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class HomeGateLogTile extends StatelessWidget {
  const HomeGateLogTile({super.key});

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
                child: Icon(FluentIcons.building_24_regular, color: OColor.green600, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OText(
                  text: 'Gatelog',
                  style: OTextStyle.headingSmall.copyWith(
                    color: OColor.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(FluentIcons.chevron_right_24_regular, color: OColor.gray400, size: 16),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: OColor.gray300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: OText(
                  text: 'To City',
                  style: OTextStyle.bodySmall.copyWith(
                    color: OColor.green600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: OColor.gray300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: OText(
                  text: 'To Khoka',
                  style: OTextStyle.bodySmall.copyWith(
                    color: OColor.green600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
