import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class CustomTextField extends StatefulWidget {
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final String? label;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final String? value;
  final void Function(String)? onChanged;
  final bool isNecessary;
  final TextEditingController? controller;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool? isEnabled;
  final int? maxLength;
  final int? maxLines;
  final bool? counter;

  const CustomTextField({
    super.key,
    this.hintText,
    this.label,
    this.validator,
    this.value,
    this.onChanged,
    required this.isNecessary,
    this.inputType,
    this.controller,
    this.onTap,
    this.isEnabled,
    this.focusNode,
    this.maxLength,
    this.maxLines,
    this.counter,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    Widget? counterBuilder(context,
        {required currentLength, required isFocused, required maxLength}) {
      if (currentLength == 0) {
        return null;
      }
      return Text("$currentLength/$maxLength",
          style: MyFonts.w500.size(12).setColor(kWhite));
    }

    return TextFormField(
      inputFormatters: widget.inputFormatters,
      enabled: widget.isEnabled ?? true,
      readOnly: widget.onTap != null,
      style: MyFonts.w500.size(14).copyWith(color: Colors.white),
      validator: widget.validator,
      controller: widget.controller,
      focusNode: widget.focusNode,
      cursorColor: lBlue2,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      buildCounter: widget.counter == true ? counterBuilder : null,
      initialValue: widget.value == 'null' ? '' : widget.value,
      keyboardType: widget.inputType,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        errorStyle: MyFonts.w500,
        hintText: widget.hintText,
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: MyFonts.w500.size(14).setColor(kTabText),
              ),
              if (widget.isNecessary)
                TextSpan(
                  text: ' * ',
                  style: MyFonts.w500.size(16).setColor(kRed),
                ),
            ],
          ),
        ),
        labelStyle: MyFonts.w500.size(14).setColor(kTabText),
        hintStyle: MyFonts.w500.size(14).setColor(kTabText),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kfocusColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kfocusColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kfocusColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
    );
  }
}
