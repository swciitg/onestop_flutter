import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class IpValues extends StatelessWidget {
  final String text;
  const IpValues({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
      child: Text(
        text,
        style: MyFonts.w400.size(14).setColor(kGrey6),
      ),
    );
  }
}
