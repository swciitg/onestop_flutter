import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/main.dart';

void showSnackBar(String message) {
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message, style: MyFonts.w500),
    ),
  );
}
