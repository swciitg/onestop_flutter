import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final String? value;
  final void Function(String)? onChanged;
  final bool isNecessary;
  final TextEditingController? controller;
  final void Function()? onTap;
  final FocusNode? focusNode;

  const CustomTextField(
      {super.key,
      required this.hintText,
      this.validator,
      this.value,
      this.onChanged,
      required this.isNecessary,
      this.inputType,
      this.controller,
      this.onTap,
      this.focusNode});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.onTap != null,
      style: MyFonts.w500.size(14).copyWith(color: Colors.white),
      validator: widget.validator,
      controller: widget.controller,
      focusNode: widget.focusNode,
      cursorColor: lBlue2,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      initialValue: widget.value == 'null' ? '' : widget.value,
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        errorStyle: MyFonts.w500,
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.hintText,
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
