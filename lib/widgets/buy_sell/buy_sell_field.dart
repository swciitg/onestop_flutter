import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestop_ui/index.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String type;
  final String? hintText;

  const InputField({super.key, required this.controller, required this.type, this.hintText});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  InputDecoration _fieldDecoration() {
    return InputDecoration(
      hintText: widget.hintText ?? '${widget.type}*',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        borderSide: BorderSide(color: OColor.gray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        borderSide: BorderSide(color: OColor.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        borderSide: BorderSide(color: OColor.green600, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        borderSide: BorderSide(color: OColor.red500),
      ),
      fillColor: OColor.white,
      filled: true,
      hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
      counterStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
      counterText:
          (widget.controller.text == "")
              ? ""
              : widget.controller.text.length.toString() +
                  ((widget.type == "Title")
                      ? "/20"
                      : (widget.type == "Contact Number"
                          ? "/10"
                          : (widget.type.toString().contains('Price') ? "/10" : "/100"))),
      contentPadding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: OSpacing.xs),
            child: Text(widget.type, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
          ),
          TextFormField(
            style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
            keyboardType:
                (widget.type == "Contact Number" || widget.type.toString().contains('Price'))
                    ? TextInputType.number
                    : TextInputType.text,
            controller: widget.controller,
            decoration: _fieldDecoration(),
            onChanged: (value) {
              setState(() {});
            },
            maxLines: (widget.type == "Description") ? 5 : 1,
            maxLength:
                (widget.type == "Title")
                    ? 20
                    : (widget.type == "Contact Number"
                        ? 10
                        : (widget.type.toString().contains('Price') ? 10 : 100)),
            validator: (value) {
              if (widget.type == "Contact Number") {
                if (value == null || value == "") {
                  return "This field cannot be null";
                }
                if (!value.trim().isNumericOnly) {
                  return "Please enter a number";
                }
                if (value.trim().length != 10) {
                  return "The contact should have 10 digits";
                }
                return null;
              } else {
                if (value == null || value == "") {
                  return "This field cannot be null";
                }
                if (widget.type.toString().contains("Price")) {
                  if (!value.trim().isNumericOnly) {
                    return "Please enter a number";
                  }
                }
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
