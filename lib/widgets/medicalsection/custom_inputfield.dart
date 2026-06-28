import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_ui/index.dart';

class CustomInputfield extends StatelessWidget {
  const CustomInputfield({
    super.key,
    required this.title,
    required this.validatortext,
    required this.hinttext,
    required this.controller,
    required this.numberkeyboard,
  });

  final String title;
  final String validatortext;
  final String hinttext;
  final bool numberkeyboard;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: OSpacing.s, top: OSpacing.s, bottom: OSpacing.xs),
          child: Text(title, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: OSpacing.s),
            decoration: BoxDecoration(
              border: Border.all(color: OColor.gray200),
              color: OColor.white,
              borderRadius: BorderRadius.circular(OCornerRadius.l),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return validatortext;
                  }
                  if (val.length < 10) {
                    return validatortext;
                  }
                  return null;
                },
                keyboardType: numberkeyboard ? TextInputType.number : TextInputType.text,
                inputFormatters: numberkeyboard ? [FilteringTextInputFormatter.digitsOnly] : [],
                controller: controller,
                maxLength: 10,
                style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
                decoration: InputDecoration(
                  errorStyle: OTextStyle.bodyXSmall.copyWith(color: OColor.red500),
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Enter your contact number',
                  hintStyle: OTextStyle.bodyMedium.copyWith(color: OColor.gray400),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
