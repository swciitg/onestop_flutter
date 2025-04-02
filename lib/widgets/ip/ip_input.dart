import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/ip/ip_calculator.dart';
import 'package:onestop_dev/functions/ip/ip_decoration.dart';
import 'package:onestop_dev/globals/my_colors.dart';

class IpField extends StatelessWidget {
  final TextEditingController control;
  final HostelDetails hostel;
  final String texta;
  final String textb;
  const IpField(
      {super.key,
      required this.control,
      required this.hostel,
      required this.texta,
      required this.textb});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextFormField(
          style: const TextStyle(color: kWhite),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return texta;
            }
            return null;
          },
          controller: control,
          keyboardType:
              (textb == 'Block') ? TextInputType.text : TextInputType.number,
          inputFormatters: (textb == 'Block')
              ? [
                  FilteringTextInputFormatter.singleLineFormatter,
                ]
              : [
                  FilteringTextInputFormatter.digitsOnly,
                ],
          onChanged: (v) {
            control.text = v;
            if (textb == 'Floor') {
              hostel.floor = v;
            } else if (textb == 'Block') {
              hostel.block = v;
            } else {
              hostel.roomNo = v;
            }
            control.selection = TextSelection.fromPosition(
                TextPosition(offset: control.text.length));
          },
          decoration: decorationFUnction(textb)),
    );
  }
}
