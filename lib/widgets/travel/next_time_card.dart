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
    return Observer(
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            color: kGrey14,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                color: lBlue5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              textColor: kWhite,
              leading: CircleAvatar(
                backgroundColor: lYellow2,
                radius: 26,
                child: (context.read<MapBoxStore>().indexBusesorFerry == 1) ? Icon(
                  FluentIcons.vehicle_ship_24_filled,
                  color: kBlueGrey,
                ) :Icon(
                  FluentIcons.vehicle_bus_24_filled,
                  color: kBlueGrey,
                ),
              ),
              title: Text(
                /*map_store.allLocationData[index]['name']*/'Madhyamkhanda',
                style: MyFonts.w500.setColor(kWhite),
              ),
              subtitle: Text(
                  /*map_store.allLocationData[index]['distance']
                      .toString() +
                      " km",*/ 'Madhyamkhanda',
                  style: MyFonts.w500.setColor(kGrey13)),
              // trailing: (map_store.allLocationData[index]['status'] ==
              //     'left')
              //     ? Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Left',
              //       style: MyFonts.w500
              //           .setColor(Color.fromRGBO(135, 145, 165, 1)),
              //     ),
              //     Text(
              //       map_store.allLocationData[index]['time'],
              //       style: MyFonts.w500
              //           .setColor(Color.fromRGBO(195, 198, 207, 1)),
              //     ),
              //   ],
              // )
              //     :
              //
              trailing: SizedBox(
                width: 80,
                child: Text(
                  'Next Bus in 1000 sec',
                  style: MyFonts.w500.setColor(lBlue2),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
