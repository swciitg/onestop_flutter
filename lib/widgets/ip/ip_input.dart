import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/functions/ip/ip_decoration.dart';

class IpField extends StatelessWidget {
  final control;
  final hostel;
  final texta;
  final textb;
  final ht;
  const IpField({Key? key, this.control, this.hostel, this.texta, this.textb, this.ht}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ht * 0.0768156,
      child: TextFormField(
          style: TextStyle(color: kWhite),
          validator: (value) {
            if (value == null ||
                value.isEmpty) {
              return texta;
            }
            return null;
          },
          controller: control,
          keyboardType:(textb=='Block')?
          TextInputType.text: TextInputType.number,
          inputFormatters: (textb=='Block')?
          [FilteringTextInputFormatter.singleLineFormatter,]:
          [FilteringTextInputFormatter.digitsOnly,],

          onChanged: (v) {
            control.text = v;
            if(textb=='Floor') {hostel.floor = v;}
            else if(textb=='Block') {hostel.block = v;}
            else {hostel.roomNo = v;}
            control.selection = TextSelection.fromPosition(TextPosition(offset: control.text.length));
          },
          decoration: decfunction(textb)),
    );
  }
}
