import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_ui/index.dart';

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
    final bool enabled = widget.isEnabled ?? true;

    Widget? counterBuilder(
      context, {
      required currentLength,
      required isFocused,
      required maxLength,
    }) {
      if (currentLength == 0) return null;
      return Text(
        "$currentLength/$maxLength",
        style: OTextStyle.labelXSmall.copyWith(color: OColor.gray400),
      );
    }

    return TextFormField(
      inputFormatters: widget.inputFormatters,
      enabled: enabled,
      readOnly: widget.onTap != null,
      style: OTextStyle.bodyMedium.copyWith(color: enabled ? OColor.gray800 : OColor.gray400),
      validator: widget.validator,
      controller: widget.controller,
      focusNode: widget.focusNode,
      cursorColor: OColor.green600,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      buildCounter: widget.counter == true ? counterBuilder : null,
      initialValue: widget.value == 'null' ? '' : widget.value,
      keyboardType: widget.inputType,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? OColor.white : OColor.gray100,
        errorStyle: OTextStyle.labelXSmall.copyWith(color: Colors.red),
        hintText: widget.hintText,
        label:
            widget.hintText == null
                ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.label,
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                      ),
                      if (widget.isNecessary)
                        TextSpan(
                          text: ' *',
                          style: OTextStyle.bodySmall.copyWith(color: Colors.red),
                        ),
                    ],
                  ),
                )
                : null,
        labelStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
        hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: OColor.green600, width: 1.5),
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: OColor.gray200, width: 1),
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: OColor.gray200, width: 1),
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
      ),
    );
  }
}
