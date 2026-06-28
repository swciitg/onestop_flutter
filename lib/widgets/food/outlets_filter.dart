import 'package:flutter/material.dart';
import 'package:onestop_ui/components/text.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';

class OutletsFilter extends StatelessWidget {
  const OutletsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return OText(
      text: "Food Outlets",
      selectable: false,
      style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
    );
  }
}
