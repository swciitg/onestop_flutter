import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';

AppBar appBar() {
  return AppBar(
    actions: [
      Padding(
        padding: EdgeInsets.all(8),
        child: IconButton(
          icon: const Icon(Icons.calendar_today),
          color: Colors.white,
          onPressed: () {},
        ),
      ),
    ],
    title: RichText(
      text: TextSpan(
          text: 'home',
          style: MyFonts.extraBold.factor(4.39).letterSpace(1.0),
          children: [
            TextSpan(
              text: '.',
              style: MyFonts.extraBold.factor(5.85).setColor(kYellow),
            )
          ]),
    ),
    elevation: 0.0,
  );
}