import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';

class TravelDropDown extends StatelessWidget {
  final String value;
  final Function onChange;
  final List<String> items;

  const TravelDropDown(
      {super.key,
      required this.value,
      required this.onChange,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: kAppBarGrey),
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            FluentIcons.chevron_down_24_regular,
            color: kWhite,
            size: 13,
          ),
          elevation: 16,
          style: MyFonts.w500.setColor(kWhite),
          onChanged: (String? newValue) {
            // context.read<TravelStore>().setBusDayString(newValue!);
            onChange(newValue!);
          },
          underline: Container(),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: MyFonts.w500,
              ),
            );
          }).toList(),
        ));
  }
}
