import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

class CarouselCard extends StatelessWidget {
  final String name;
  final int index;

  const CarouselCard({Key? key, required this.index, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> getNextTime() async {
      String today = getFormattedDay();
      if (context.read<MapBoxStore>().indexBusesorFerry == 0) {
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
          return 'Next Bus at: ${nextTime(busTimes[1], firstTime: busTimes[0][0])}';
        } else if (today == 'Sun') {
          return 'Next Bus at: ${nextTime(busTimes[0], firstTime: busTimes[1][0])}';
        } else if (today == 'Sat') {
          return 'Next Bus at: ${nextTime(busTimes[0])}';
        }
        return 'Next Bus at: ${nextTime(busTimes[1])}';
      } else {
        var ferryTimes = await DataProvider.getFerryTimings();
        var requiredModel =
            ferryTimes.firstWhere((element) => element.name == name);
        if (today == 'Sat') {
          return 'Next Ferry at: ${nextTime(requiredModel.MonToFri_NorthGuwahatiToGuwahati, firstTime: requiredModel.Sunday_NorthGuwahatiToGuwahati[0])}';
        } else if (today == 'Sun') {
          return 'Next Ferry at: ${nextTime(requiredModel.Sunday_NorthGuwahatiToGuwahati, firstTime: requiredModel.MonToFri_NorthGuwahatiToGuwahati[0])}';
        }
        return 'Next Ferry at: ${nextTime(requiredModel.MonToFri_NorthGuwahatiToGuwahati)}';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 3.0, right: 3),
      child: Observer(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(34, 36, 41, 1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                color:
                    (context.read<MapBoxStore>().selectedCarouselIndex == index)
                        ? lBlue5
                        : kTileBackground),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    backgroundColor: lYellow2,
                    radius: 16,
                    child: Icon(
                      context.read<MapBoxStore>().indexBusesorFerry == 0
                          ? FluentIcons.vehicle_bus_24_filled
                          : FluentIcons.vehicle_ship_24_filled,
                      color: kBlueGrey,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: MyFonts.w600.size(14).setColor(kWhite),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                          future: getNextTime(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data! as String,
                                style: MyFonts.w500.size(11).setColor(kGrey13),
                              );
                            }
                            return Container();
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
