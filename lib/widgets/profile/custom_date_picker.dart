import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

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
        colorScheme: ColorScheme.light(
          primary: OColor.green600,
          onPrimary: OColor.white,
          surface: OColor.white,
          onSurface: OColor.gray800,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: OColor.green600),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: OColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ),
      child: widget.child!,
    );
  }
}
