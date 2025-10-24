import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeServiceTile extends StatelessWidget {
  const HomeServiceTile({
    super.key,
    required this.label,
    this.iconCode,
    this.icon,
    this.routeId,
    this.link,
    this.newBadge = false,
  });

  final String label;
  final String? link;
  final IconData? icon;
  final int? iconCode;
  final String? routeId;
  final bool newBadge;

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return newBadge ? buildBadge(context) : buildTile(context);
  }

  Badge buildBadge(BuildContext context) {
    return Badge(
      position: BadgePosition.topEnd(top: 3),
      badgeStyle: BadgeStyle(
        badgeColor: kBadgeColor,
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(8),
      ),
      badgeContent: Text('New', style: MyFonts.w600.setColor(kGrey9).size(10)),
      child: buildTile(context),
    );
  }

  Widget buildTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (link != null) {
          launchURL(link!);
        } else {
          Navigator.pushNamed(context, routeId ?? "/");
        }
      },
      child: SizedBox(
        height: 150,
        width: 150,
        child: Column(
          // Replace with a Row for horizontal icon + text
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Icon(
                icon ?? IconData(iconCode!, fontFamily: 'MaterialIcons'),
                size: 32,
                color: OColor.green600,
              ),
            ),
            Expanded(
              child: OText(
                text: label,
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.gray800,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
