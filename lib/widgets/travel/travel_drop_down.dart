import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:provider/provider.dart';

class TravelDropDown extends StatelessWidget {
  const TravelDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(canvasColor: kAppBarGrey),
      child: Observer(
        builder: (context) {
          return DropdownButton<String>(
            value: context.read<TravelStore>().busDayType,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: kWhite,
              size: 13,
            ),
            elevation: 16,
            style: MyFonts.w500.setColor(kWhite),
            onChanged: (String? newValue) {
              context.read<TravelStore>().setBusDayString(newValue!);
            },
            underline: Container(),
            items: <String>['Weekdays', 'Weekends']
                .map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: MyFonts.w500,
                    ),
                  );
                }).toList(),
          );
        }
      ),
    );
  }
}
