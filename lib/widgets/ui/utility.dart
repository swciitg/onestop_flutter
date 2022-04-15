import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class TextTile extends StatelessWidget {
  TextTile({
    Key? key,
    required this.text,
    required this.FontSize,
    required this.Style,
  }) : super(key: key);

  final String text;
  final double FontSize;
  final TextStyle Style;

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    if ((text.length) * 10 < Width * 0.6) {
      return Text(
        text,
        style: Style,
      );
    } else {
      return Container(
        height: FontSize + 5.0,
        width: Width * 0.45,
        child: Marquee(
          text: text + " " * 6,
          style: Style,
          numberOfRounds: 50,
          velocity: 25,
          pauseAfterRound: Duration(seconds: 2),
        ),
      );
    }
  }
}
