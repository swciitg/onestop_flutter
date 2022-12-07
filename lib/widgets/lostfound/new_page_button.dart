import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class NextButton extends StatelessWidget {
  final String title;
  const NextButton({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration:
          BoxDecoration(color: lBlue2, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: MyFonts.w500.size(14),
          ),
        ],
      ),
    );
  }
}
