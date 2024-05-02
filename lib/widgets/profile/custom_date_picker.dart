import 'package:flutter/material.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class CustomDatePicker extends StatefulWidget {
  final Widget? child;
  const CustomDatePicker({super.key, this.child});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          headline4: MyFonts.w500,
          headline5: MyFonts.w500, // Selected Date landscape
          headline6: MyFonts.w500, // Selected Date portrait
          overline: MyFonts.w500, // Title - SELECT DATE
          bodyText1: MyFonts.w500, // year gridbview picker
          subtitle1: MyFonts.w500, // input
          subtitle2: MyFonts.w500, // month/year picker
          caption: MyFonts.w500, // days
        ),
        colorScheme: const ColorScheme.dark(
          primary: lBlue4,
          surface: kdatePickerSurfaceColor,
        ),
        dialogBackgroundColor: kdatePickerSurfaceColor,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: kdatePickerSurfaceColor, // button
              foregroundColor: lBlue2,
              elevation: 0,
              textStyle: MyFonts.w500),
        ),
      ),
      child: widget.child!,
    );
  }
}
