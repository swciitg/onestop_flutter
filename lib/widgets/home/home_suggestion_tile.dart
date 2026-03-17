import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onestop_dev/pages/services/cab_share.dart';
import 'package:onestop_dev/widgets/home/home_widget.dart';
import 'package:onestop_ui/index.dart';

class HomeSuggestionTile extends StatelessWidget {
  const HomeSuggestionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CabShare.id);
      },
      child: HomeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(FluentIcons.star_12_filled, color: OColor.yellow500, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: OText(
                    text: 'Suggestion',
                    style: OTextStyle.headingSmall.copyWith(
                      color: OColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: RichText(
                text: TextSpan(
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                  children: [
                    const TextSpan(text: 'Going Home? '),
                    TextSpan(
                      text: 'Share a Cab',
                      style: OTextStyle.bodySmall.copyWith(color: OColor.green600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: SvgPicture.asset(
                "assets/images/cab_sharing.svg",
                width: 32,
                height: 32,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 28,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, CabShare.id);
                },
                icon: OText(
                  text: 'Cab Sharing',
                  style: OTextStyle.labelSmall.copyWith(
                    color: OColor.green600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                label: Icon(FluentIcons.arrow_up_right_16_regular, color: OColor.green600, size: 16),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: OColor.gray300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
