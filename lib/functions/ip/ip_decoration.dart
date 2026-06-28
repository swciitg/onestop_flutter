import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

InputDecoration ipInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
    contentPadding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      borderSide: BorderSide(color: OColor.green600, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      borderSide: BorderSide(color: OColor.gray300, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      borderSide: BorderSide(color: OColor.red400, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      borderSide: BorderSide(color: OColor.red400, width: 1.5),
    ),
  );
}

/// Keep old name as alias for backward compat
InputDecoration decorationFunction(String x) => ipInputDecoration(x);
