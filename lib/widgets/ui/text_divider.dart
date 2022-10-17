import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    Key? key,
    required this.text

  }) : super(key: key);
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
