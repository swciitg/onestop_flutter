import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class CustomHintTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final bool? counter;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final BorderRadius? borderRadius;

  const CustomHintTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.maxLines,
    this.maxLength,
    this.counter = false,
    this.inputType,
    this.validator,
    this.borderRadius,
  });

  @override
  State<CustomHintTextField> createState() => _CustomHintTextFieldState();
}

class _CustomHintTextFieldState extends State<CustomHintTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: MyFonts.w500.size(14).copyWith(color: Colors.white),
      validator: widget.validator,
      controller: widget.controller,
      cursorColor: lBlue2,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      buildCounter: widget.counter == true ? counterBuilder : null,
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        errorStyle: MyFonts.w500,
        hintText: widget.hintText,
        hintStyle: MyFonts.w500.size(14).setColor(kTabText),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kfocusColor, width: 1),
          borderRadius: widget.borderRadius ??
              const BorderRadius.all(
                Radius.circular(4),
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kfocusColor, width: 1),
          borderRadius: widget.borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kfocusColor, width: 1),
          borderRadius: widget.borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: widget.borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: widget.borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
      ),
    );
  }

  Widget? counterBuilder(context,
      {required currentLength, required isFocused, required maxLength}) {
    if (currentLength == 0) {
      return null;
    }
    return Text("$currentLength/$maxLength",
        style: MyFonts.w500.size(12).setColor(kWhite));
  }
}
