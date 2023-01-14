import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class HomeTabTile extends StatelessWidget {
  const HomeTabTile(
      {Key? key,
      required this.label,
      required this.icon,
      this.routeId,
      this.newBadge = false})
      : super(key: key);

  final String label;
  final IconData icon;
  final String? routeId;
  final bool newBadge;

  @override
  Widget build(BuildContext context) {
    Widget finalWidget = FittedBox(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, routeId ?? "/"),
        child: Container(
          //margin: EdgeInsets.all(4),
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: lGrey),
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
                  icon,
                  size: 40,
                  color: lBlue,
                ),
              ),
              Expanded(
                child: Text(label,
                    style: MyFonts.w500.size(23).setColor(lBlue),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
    if (newBadge) {
      finalWidget = Badge(
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(8),
        badgeContent: Text(
          'New',
          style: MyFonts.w600.setColor(kGrey9).size(10),
        ),
        badgeColor: kBadgeColor,
        child: finalWidget,
      );
    }
    return Expanded(
      child: finalWidget,
    );
  }
}
