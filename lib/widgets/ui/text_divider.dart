import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider(color: OColor.gray300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.xs),
            child: Text(text, style: OTextStyle.labelXSmall.copyWith(color: OColor.gray500)),
          ),
          Expanded(child: Divider(color: OColor.gray300)),
        ],
      ),
    );
  }
}
