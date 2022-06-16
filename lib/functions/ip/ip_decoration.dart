import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

decfunction(String x) {
  return InputDecoration(
    labelText: x,
    labelStyle: MyFonts.w500.setColor(kGrey7),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: kGrey7, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: kGrey7,
        width: 1,
      ),
    ),
  );
}
