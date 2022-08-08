import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class ContactText extends StatelessWidget {
  final String text;
  final align;
  const ContactText({Key? key, required this.text, this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          alignment: align,
          child: Text(
            text,
            style: MyFonts.w400.size(14).setColor(lBlue2),
          ),
        ),
      ),
    );
  }
}

class ContactTextHeader extends StatelessWidget {
  final text;
  final width;
  final align;
  const ContactTextHeader({Key? key, this.text, this.width, this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        alignment: align,
        width: width,
        child: Text(
          text,
          style: MyFonts.w500.size(12).setColor(kGrey11),
        ),
      ),
    );
  }
}
