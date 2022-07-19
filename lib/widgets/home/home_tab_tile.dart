import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class HomeTabTile extends StatelessWidget {
  HomeTabTile({Key? key, required this.label, required this.icon, this.routeId})
      : super(key: key);

  final String label;
  final IconData icon;
  final String? routeId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeId ?? "/"),
      child: Container(
        //margin: EdgeInsets.all(4),
        // height: 50,
        width: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), color: lGrey),
        padding: EdgeInsets.all(6.0),
        child: Column(
          // Replace with a Row for horizontal icon + text
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              icon,
              size: 20,
              color: lBlue,
            ),
            Text(label,
                style: MyFonts.w500.size(13).setColor(lBlue),
                textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
