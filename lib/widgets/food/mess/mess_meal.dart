import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class MessMeal extends StatelessWidget {
  const MessMeal({
    Key? key,
    required this.mealName,
    this.selected = false,
  }) : super(key: key);

  final String mealName;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          color: selected ? lBlue2 : kGrey9,
        ),
        alignment: Alignment.center,
        child: Text(
          mealName,
          style: selected
              ? MyFonts.w500
                  .size(screenWidth <= 380 ? 13 : 14)
                  .setColor(kBlueGrey)
              : MyFonts.w500
                  .size(screenWidth <= 380 ? 13 : 14)
                  .setColor(Color.fromRGBO(91, 146, 227, 1)),
        ),
      ),
    );
  }
}
