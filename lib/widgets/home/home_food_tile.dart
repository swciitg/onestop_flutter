import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onestop_dev/widgets/home/home_widget.dart';
import 'package:onestop_ui/index.dart';

class HomeFoodTile extends StatelessWidget {
  final VoidCallback moveToFoodMenu;
  const HomeFoodTile({super.key, required this.moveToFoodMenu});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: moveToFoodMenu,
      child: HomeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/images/food.svg", width: 20, height: 20),
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
                    icon: Icon(
                      FluentIcons.chevron_right_24_regular,
                      color: OColor.gray400,
                      size: 16,
                    ),
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
      ),
    );
  }
}
