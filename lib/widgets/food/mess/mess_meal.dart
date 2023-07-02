import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/mess_store.dart';
import 'package:provider/provider.dart';
class MessMeal extends StatelessWidget {
  const MessMeal({
    Key? key,
    required this.mealName,
  }) : super(key: key);
  final String mealName;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<MessStore>().setMeal(mealName);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Observer(builder: (context) {
            bool selected = context.read<MessStore>().selectedMeal == mealName;
            return Container(
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
                    .setColor(const Color.fromRGBO(91, 146, 227, 1)),
              ),
            );
          }),
        ),
      ),
    );
  }
}