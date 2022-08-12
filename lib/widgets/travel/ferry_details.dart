import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/timing_tile.dart';
import 'package:onestop_dev/widgets/travel/travel_drop_down.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/globals/travel_details.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';

class FerryDetails extends StatelessWidget {
  const FerryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TravelDropDown(
                value: context.read<TravelStore>().ferryDirection,
                onChange: context.read<TravelStore>().setFerryDirection,
                items: ["Campus to City", "City to Campus"]),
            TravelDropDown(
                value: context.read<TravelStore>().ferryDayType,
                onChange: context.read<TravelStore>().setFerryDayType,
                items: ["Mon - Sat", "Sunday"])
          ],
        ),
        Column(
          children:
              FERRYTIME[context.read<TravelStore>().ferryDataIndex].map((e) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: TimingTile(
                time: e,
                isLeft: hasLeft(e.toString()),
                icon: FluentIcons.vehicle_ship_24_filled,
              ),
            );
          }).toList(),
        )
      ]);
    });
  }
}
