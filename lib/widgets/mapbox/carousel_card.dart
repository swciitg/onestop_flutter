import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/services/api.dart';
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
    Future<Object> getNextTime() async {
      String today = getFormattedDay();
      if (context.read<MapBoxStore>().indexBusesorFerry == 0) {
        // List<TravelTiming> allBusTimes = await APIService().getBusTiming();
        List<TravelTiming> allBusTimes = await DataProvider.getBusTiming();
        List<DateTime> weekdaysTimes = [];
        List<DateTime> weekendTimes = [];
        for (var xyz in allBusTimes) {
          int n = xyz.weekdays.fromCampus.length;
          for (int i = 0; i < n; i++) {
            weekdaysTimes.add(xyz.weekdays.fromCampus[i]);
          }
        }
        weekdaysTimes.sort((a, b) => a.compareTo(b));
        for (var xyz in allBusTimes) {
          int n = xyz.weekend.fromCampus.length;
          for (int i = 0; i < n; i++) {
            weekendTimes.add(xyz.weekend.fromCampus[i]);
          }
        }
        weekendTimes.sort((a, b) => a.compareTo(b));

        if (today == 'Fri') {
          return 'Next Bus at: ${nextTime(weekdaysTimes, firstTime: weekendTimes[0].toString())}';
        } else if (today == 'Sun') {
          return 'Next Bus at: ${nextTime(weekendTimes, firstTime: weekdaysTimes[0].toString())}';
        } else if (today == 'Sat') {
          return 'Next Bus at: ${nextTime(weekendTimes)}';
        }
        return 'Next Bus at: ${nextTime(weekdaysTimes)}';
      } else {
        // List<TravelTiming> ferryTimings = await APIService().getFerryTiming();
        List<TravelTiming> ferryTimings = await DataProvider.getFerryTiming();
        List<DateTime> weekdaysTimes = [];
        List<DateTime> weekendTimes = [];
        TravelTiming requiredModel =
            ferryTimings.firstWhere((element) => element.stop == name);

        int n = requiredModel.weekdays.fromCampus.length;
        for (int i = 0; i < n; i++) {
          weekdaysTimes.add(requiredModel.weekdays.fromCampus[i]);
        }
        weekdaysTimes.sort((a, b) => a.compareTo(b));
        int p = requiredModel.weekend.fromCampus.length;
        for (int i = 0; i < p; i++) {
          weekendTimes.add(requiredModel.weekend.fromCampus[i]);
        }
        weekendTimes.sort((a, b) => a.compareTo(b));
        if (today == 'Sat') {
          return 'Next Ferry at: ${nextTime(weekdaysTimes, firstTime: weekendTimes[0].toString())}';
        } else if (today == 'Sun') {
          return 'Next Ferry at: ${nextTime(weekendTimes, firstTime: weekdaysTimes[0].toString())}';
        }
        return 'Next Ferry at: ${nextTime(weekdaysTimes)}';
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
