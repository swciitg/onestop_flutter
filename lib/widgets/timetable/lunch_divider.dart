import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class LunchDivider extends StatelessWidget {
  const LunchDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: Divider(
        color: kGrey8,
      )),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          'Lunch Break',
          style: MyFonts.w500.size(12).setColor(kGrey8),
        ),
      ),
      Expanded(
          child: Divider(
        color: kGrey8,
      )),
    ]);
  }
}
