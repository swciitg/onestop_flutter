import 'package:onestop_dev/globals/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class IpValues extends StatelessWidget {
  final text;
  const IpValues({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,8.0,8.0,8.0),
      child: Text(
        text,
        style: MyFonts.regular.size(14).setColor(kGrey6),
      ),
    );
  }
}
