import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_kit/onestop_kit.dart';

class CustomInputfield extends StatelessWidget {
  const CustomInputfield(
      {super.key,
      required this.title,
      required this.validatortext,
      required this.hinttext,
      required this.controller,
      required this.numberkeyboard});

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
          padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
          child: Text(
            title,
            style: OnestopFonts.w600.size(16).setColor(kWhite),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                border: Border.all(color: kGrey2),
                color: kBackground,
                borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                keyboardType:
                    numberkeyboard ? TextInputType.number : TextInputType.text,
                inputFormatters: numberkeyboard
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : [],
                controller: controller,
                maxLength: 10,
                style: OnestopFonts.w500.size(16).setColor(kWhite),
                decoration: InputDecoration(
                  errorStyle: OnestopFonts.w400,
                  counterText: "",
                  border: InputBorder.none,
                  hintText: 'Enter your contact number',
                  hintStyle: const TextStyle(color: kGrey8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
