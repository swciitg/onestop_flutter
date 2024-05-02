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
          headlineMedium: MyFonts.w500,
          headlineSmall: MyFonts.w500, // Selected Date landscape
          titleLarge: MyFonts.w500, // Selected Date portrait
          labelSmall: MyFonts.w500, // Title - SELECT DATE
          bodyLarge: MyFonts.w500, // year gridbview picker
          titleMedium: MyFonts.w500, // input
          titleSmall: MyFonts.w500, // month/year picker
          bodySmall: MyFonts.w500, // days
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
