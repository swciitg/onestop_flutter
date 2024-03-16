import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/main.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTabTile extends StatelessWidget {
  const HomeTabTile(
      {Key? key,
      required this.label,
      this.iconCode,
      this.icon,
      this.routeId,
      this.link,
      this.newBadge = false})
      : super(key: key);

  final String label;
  final String? link;
  final IconData? icon;
  final int? iconCode;
  final String? routeId;
  final bool newBadge;

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return newBadge ? buildNewBadge() : buildBody();
  }

  Widget buildBody() {
    return FittedBox(
      child: GestureDetector(
        onTap: () {
          if (link != null) {
            launchURL(link!);
          } else {
            navigatorKey.currentState!.pushNamed(routeId ?? "/");
          }
        },
        child: Container(
          //margin: EdgeInsets.all(4),
          height: 150,
          width: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: lGrey),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            // Replace with a Row for horizontal icon + text
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Icon(
                  icon ?? IconData(iconCode!, fontFamily: 'MaterialIcons'),
                  size: 40,
                  color: lBlue,
                ),
              ),
              Expanded(
                child: Text(label,
                    style: MyFonts.w500.size(23).setColor(lBlue), textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNewBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: -4, end: -4),
      shape: BadgeShape.square,
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(
        'New',
        style: MyFonts.w600.setColor(kGrey9).size(10),
      ),
      badgeColor: kBadgeColor,
      child: buildBody(),
    );
  }
}
