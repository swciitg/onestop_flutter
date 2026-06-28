import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class IpValues extends StatelessWidget {
  final String text;

  const IpValues({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
      child: Text(text, style: OTextStyle.bodySmall.copyWith(color: OColor.gray600)),
    );
  }
}
