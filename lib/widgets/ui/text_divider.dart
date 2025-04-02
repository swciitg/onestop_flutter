import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Expanded(
          child: Divider(
        color: kGrey8,
      )),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: MyFonts.w500.size(12).setColor(kGrey8),
        ),
      ),
      const Expanded(
          child: Divider(
        color: kGrey8,
      )),
    ]);
  }
}
