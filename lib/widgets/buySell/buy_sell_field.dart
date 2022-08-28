import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String type;
  const InputField({Key? key, required this.controller, required this.type}) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextFormField(
        style: MyFonts.w500.size(15).setColor(kWhite),
        keyboardType: (widget.type == "Contact Number" ||
                widget.type.toString().contains('Price'))
            ? TextInputType.number
            : TextInputType.text,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: '${widget.type}*',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          fillColor: kAppBarGrey,
          filled: true,
          hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
          counterStyle: MyFonts.w500.size(12).setColor(kWhite),
          counterText: (widget.controller.text == "")
              ? ""
              : widget.controller.text.length.toString() +
                  ((widget.type == "Title")
                      ? "/20"
                      : (widget.type == "Contact Number"
                          ? "/10"
                          : (widget.type.toString().contains('Price')
                              ? "/10"
                              : "/100"))),
        ),
        onChanged: (value) {
          setState(() {});
        },
        maxLines: (widget.type == "Description") ? 10 : 1,
        maxLength: (widget.type == "Title")
            ? 20
            : (widget.type == "Contact Number"
                ? 10
                : (widget.type.toString().contains('Price') ? 10 : 100)),
        validator: (value) {
          if (widget.type == "Contact Number") {
            if (value == null || value == "") {
              return "This field cannot be null";
            }
            if (value.trim().length != 10) {
              return "The contact should have 10 digits";
            }
            return null;
          } else {
            if (value == null || value == "") {
              return "This field cannot be null";
            }
            return null;
          }
        },
      ),
    );
  }
}
