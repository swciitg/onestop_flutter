import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/functions/travel/distance.dart';
import 'package:onestop_dev/functions/travel/duration_left.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class NextTimeCard extends StatefulWidget {
  const NextTimeCard({super.key});

  @override
  State<NextTimeCard> createState() => _NextTimeCardState();
}

class _NextTimeCardState extends State<NextTimeCard> {
  @override
  Widget build(BuildContext context) {
    var travelStore = context.read<TravelStore>();

    var mapStore = context.read<MapBoxStore>();
    Future<String> getNextTime() async {
      String today = getFormattedDay();
      if (mapStore.indexBusesorFerry == 0) {
        List<TravelTiming> allBusTimes = await travelStore.getBusTimings();
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
          return nextTime(weekdaysTimes, firstTime: weekendTimes[0].toString());
        } else if (today == 'Sun') {
          return nextTime(weekendTimes, firstTime: weekdaysTimes[0].toString());
        } else if (today == 'Sat') {
          return nextTime(weekendTimes);
        }
        return nextTime(weekdaysTimes);
      } else {
        List<TravelTiming> ferryTimings = await travelStore.getFerryTimings();
        List<DateTime> weekdaysTimes = [];
        List<DateTime> weekendTimes = [];
        TravelTiming requiredModel = ferryTimings.firstWhere((element) =>
            element.stop ==
            mapStore.allLocationData[mapStore.selectedCarouselIndex]['name']);
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
          return nextTime(weekdaysTimes, firstTime: weekendTimes[0].toString());
        } else if (today == 'Sun') {
          return nextTime(weekendTimes, firstTime: weekdaysTimes[0].toString());
        }
        return nextTime(weekdaysTimes);
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
              child: (mapStore.indexBusesorFerry == 1)
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
