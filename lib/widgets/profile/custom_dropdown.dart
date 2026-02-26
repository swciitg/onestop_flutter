import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final String? label;
  final Function? onChanged;
  final String? Function(String?)? validator;
  final int? index;
  final String? value;
  final BorderRadius? borderRadius;
  final bool? isNecessary;
  final Widget? icon;

  const CustomDropDown({
    super.key,
    required this.items,
    this.hintText,
    this.label,
    required this.onChanged,
    this.index,
    this.value,
    this.borderRadius,
    required this.validator,
    this.isNecessary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(OCornerRadius.m);
    return DropdownButtonFormField(
      validator: validator,
      menuMaxHeight: 400,
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: OColor.white,
        hintText: hintText,
        label:
            hintText == null
                ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: label,
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                      ),
                      if (isNecessary!)
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
        errorStyle: OTextStyle.labelXSmall.copyWith(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: OColor.green600, width: 1.5),
          borderRadius: radius,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: OColor.gray200, width: 1),
          borderRadius: radius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: radius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: radius,
        ),
      ),
      dropdownColor: OColor.white,
      isDense: true,
      icon: icon ?? Icon(Icons.arrow_drop_down, size: 28, color: OColor.gray600),
      elevation: 4,
      style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
      onChanged: (String? value) {
        if (index != null) {
          onChanged!(value, index);
        } else {
          onChanged!(value);
        }
      },
      items:
          items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
    );
  }
}
