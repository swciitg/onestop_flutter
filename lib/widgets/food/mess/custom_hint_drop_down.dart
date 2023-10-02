import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class CustomHintDropDown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final int? index;
  final String? value;
  final BorderRadius? borderRadius;
  final bool? isInputInt;

  const CustomHintDropDown(
      {super.key,
      required this.items,
      required this.hintText,
      required this.onChanged,
      this.index,
      this.value,
      this.borderRadius,
      this.isInputInt,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: validator,
      menuMaxHeight: 400,
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: MyFonts.w600.size(14).setColor(kWhite),
        errorStyle: MyFonts.w500,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kfocusColor, width: 1),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(4),
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kfocusColor, width: 1),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(4),
              ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(4),
              ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(4),
              ),
        ),
      ),
      dropdownColor: kBackground,
      isDense: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 24,
        color: kWhite,
      ),
      elevation: 16,
      style: MyFonts.w600.size(14).setColor(kWhite),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
