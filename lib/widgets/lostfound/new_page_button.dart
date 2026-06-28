import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class NextButton extends StatelessWidget {
  final String title;

  const NextButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: OSpacing.s, right: OSpacing.s, bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: OSpacing.m),
      decoration: BoxDecoration(
        color: OColor.green600,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(title, style: OTextStyle.labelMedium.copyWith(color: OColor.white))],
      ),
    );
  }
}
