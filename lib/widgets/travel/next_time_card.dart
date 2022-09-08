import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/functions/travel/distance.dart';
import 'package:onestop_dev/functions/travel/duration_left.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

class NextTimeCard extends StatefulWidget {
  const NextTimeCard({Key? key}) : super(key: key);

  @override
  State<NextTimeCard> createState() => _NextTimeCardState();
}

class _NextTimeCardState extends State<NextTimeCard> {
  @override
  Widget build(BuildContext context) {
    var mapStore = context.read<MapBoxStore>();
    Future<String> getNextTime() async {
      String today = getFormattedDay();
      if (mapStore.indexBusesorFerry == 0) {
        var allBusTimes = await DataProvider.getBusTimings();
        List<List<String>> busTimes = [[],[]];
        allBusTimes.forEach((key, list) {
          for(String time in list[0])
            {
              busTimes[0].add(time);
            }
          for(String time in list[1])
          {
            busTimes[1].add(time);
          }
        });
        busTimes[0].sort((a, b) => parseTime(a).compareTo(parseTime(b)));
        busTimes[1].sort((a, b) => parseTime(a).compareTo(parseTime(b)));
        if (today == 'Fri') {
          return nextTime(busTimes[1], firstTime: busTimes[0][0]);
        } else if (today == 'Sun') {
          return nextTime(busTimes[0], firstTime: busTimes[1][0]);
        } else if (today == 'Sat') {
          return nextTime(busTimes[0]);
        }
        return nextTime(busTimes[1]);
      } else {
        var ferryTimes = await DataProvider.getFerryTimings();
        var requiredModel = ferryTimes.firstWhere((element) =>
            element.name ==
            mapStore.allLocationData[mapStore.selectedCarouselIndex]['name']);
        if (today == 'Sat') {
          return nextTime(requiredModel.MonToFri_NorthGuwahatiToGuwahati,
              firstTime: requiredModel.Sunday_NorthGuwahatiToGuwahati[0]);
        } else if (today == 'Sun') {
          return nextTime(requiredModel.Sunday_NorthGuwahatiToGuwahati,
              firstTime: requiredModel.MonToFri_NorthGuwahatiToGuwahati[0]);
        }
        return nextTime(requiredModel.MonToFri_NorthGuwahatiToGuwahati);
      }
    }

    return Observer(builder: (context) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: kGrey14,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                  ? const Icon(
                      FluentIcons.vehicle_ship_24_filled,
                      color: kBlueGrey,
                    )
                  : const Icon(
                      FluentIcons.vehicle_bus_24_filled,
                      color: kBlueGrey,
                    ),
            ),
            title: Text(
              mapStore.allLocationData[mapStore.selectedCarouselIndex]['name'],
              style: MyFonts.w500.setColor(kWhite).size(14),
            ),
            subtitle: Text(
                "${calculateDistance(mapStore.selectedCarouselLatLng, mapStore.userLatLng).toStringAsFixed(2)} km",
                style: MyFonts.w500.setColor(kGrey13).size(11)),
            trailing: FutureBuilder(
                future: getNextTime(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                        width: 80,
                        child: (mapStore.indexBusesorFerry == 0)
                            ? Text(
                                'Next Bus in ${durationLeft(snapshot.data.toString())}',
                                style: MyFonts.w500.setColor(lBlue2).size(14),
                              )
                            : Text(
                                'Next Ferry in ${durationLeft(snapshot.data.toString())}',
                                style: MyFonts.w500.setColor(lBlue2).size(14),
                              ));
                  }
                  return const CircularProgressIndicator();
                }),
          ),
        ),
      );
    });
  }
}
