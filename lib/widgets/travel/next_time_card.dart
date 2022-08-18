import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

class NextTimeCard extends StatefulWidget {
  NextTimeCard({Key? key}) : super(key: key);

  @override
  State<NextTimeCard> createState() => _NextTimeCardState();
}

class _NextTimeCardState extends State<NextTimeCard> {
  @override
  Widget build(BuildContext context) {
    var mapStore = context.read<MapBoxStore>();
    return Observer(builder: (context) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: kGrey14,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: lBlue5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            textColor: kWhite,
            leading: CircleAvatar(
              backgroundColor: lYellow2,
              radius: 20,
              child: (context.read<MapBoxStore>().indexBusesorFerry == 1)
                  ? Icon(
                FluentIcons.vehicle_ship_24_filled,
                color: kBlueGrey,
              )
                  : Icon(
                FluentIcons.vehicle_bus_24_filled,
                color: kBlueGrey,
              ),
            ),
            title:Text(
              mapStore.allLocationData[mapStore.selectedCarouselIndex]['name'],
              style: MyFonts.w500.setColor(kWhite).size(14),
            ),
            subtitle: Text(
                mapStore.allLocationData[mapStore.selectedCarouselIndex]['distance']
                    .toString() +
                    " km",
                style: MyFonts.w500.setColor(kGrey13).size(11)),
            trailing: SizedBox(
                width: 80,
                child: (mapStore.indexBusesorFerry == 0) ?Text(
                  'Next Bus in 15 min',
                  style: MyFonts.w500.setColor(lBlue2).size(14),
                ) : Text(
                  'Next Ferry in 15 min',
                  style: MyFonts.w500.setColor(lBlue2).size(14),
                )
            ),
          ),
        ),
      );
    });
  }
}