import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class MedicalContactDisplay extends StatelessWidget {
  final String text;
  final AlignmentDirectional align;

  const MedicalContactDisplay({super.key, required this.text, required this.align});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: OSpacing.xs),
        child: Container(
          alignment: align,
          child: Text(text, style: OTextStyle.bodySmall.copyWith(color: OColor.blue500)),
        ),
      ),
    );
  }
}

class MedicalContactDisplayHeader extends StatelessWidget {
  final String text;
  final double width;
  final AlignmentDirectional align;

  const MedicalContactDisplayHeader({
    super.key,
    required this.text,
    required this.width,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: OSpacing.xs),
      child: Container(
        alignment: align,
        width: width,
        child: Text(text, style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray600)),
      ),
    );
  }
}
