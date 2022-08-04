import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'ferry_details.dart';

class DropButton extends StatefulWidget {
  int day;
  List<String> data;
  final Function() f;
  DropButton({Key? key, required this.day, required this.data, required this.f}) : super(key: key);

  @override
  State<DropButton> createState() => _DropButtonState();
}

class _DropButtonState extends State<DropButton> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: kAppBarGrey),
      child: DropdownButton<String>(
        value: (widget.day == 1)?day:from,
        icon: const Icon(Icons.arrow_drop_down, color: kWhite, size: 13,),
        elevation: 16,
        style: MyFonts.w500.setColor(kWhite),
        onChanged: (String? newValue) {
          setState(() {
            if(widget.day == 1) {day = newValue!;}
            else{from = newValue!;}
            widget.f();
          });
        },
        underline: Container(),
        items: widget.data
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: MyFonts.w500,),
          );
        }).toList(),
      ),
    );
  }
}
