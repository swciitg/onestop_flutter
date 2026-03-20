import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_ui/index.dart';

void showSnackBar(String message) {
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: OText(text: message, style: OTextStyle.bodySmall.copyWith(color: OColor.black)),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: OColor.white,
    ),
  );
}

void showErrorSnackBar(DioException err) {
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: OText(
        text:
            (err.response != null)
                ? err.response!.data['message']
                : "Some error occurred. try again",
        style: OTextStyle.bodySmall.copyWith(color: OColor.white),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: OColor.black,
    ),
  );
}
