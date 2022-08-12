import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:provider/provider.dart';

class TravelDropDown extends StatelessWidget {
  String value;
  Function onChange;
  List<String> items;
  TravelDropDown(
      {Key? key,
      required this.value,
      required this.onChange,
      required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: kAppBarGrey),
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.arrow_drop_down,
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
