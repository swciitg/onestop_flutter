import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';

class HomeTabTile extends StatelessWidget {
  HomeTabTile({
    Key? key,
    required this.label,
    required this.icon
  }) : super(key: key);

  final String label;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        child: Container(
          //margin: EdgeInsets.all(4),
          height: 120,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: lGrey),
          padding: EdgeInsets.all(4.0),
          child: Column(
            // Replace with a Row for horizontal icon + text
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                icon,
                size: 30,
                color: lBlue,
              ),
              Text(label,
                  style: MyFonts.medium.size(23).setColor(lBlue),
                  textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}
