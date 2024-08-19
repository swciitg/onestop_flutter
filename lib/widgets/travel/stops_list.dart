import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/functions/travel/distance.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class BusStopList extends StatelessWidget {
  const BusStopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: context.read<MapBoxStore>().allLocationData.length,
        itemBuilder: (BuildContext context, int index) {
          var mapStore = context.read<MapBoxStore>();
          var travelStore = context.read<TravelStore>();
          return FutureBuilder<List<TravelTiming>>(
            future: travelStore.getBusTimings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TravelTiming>? busTime = snapshot.data;
                if (busTime!.isEmpty) {
                  return Container();
                }
                List<DateTime> weekdaysTimes = [];
                List<DateTime> weekendTimes = [];
                for (var xyz in busTime) {
                  int n = xyz.weekdays.fromCampus.length;
                  for (int i = 0; i < n; i++) {
                    weekdaysTimes.add(xyz.weekdays.fromCampus[i]);
                  }
                }
                weekdaysTimes.sort((a, b) => a.compareTo(b));
                for (var xyz in busTime) {
                  int n = xyz.weekend.fromCampus.length;
                  for (int i = 0; i < n; i++) {
                    weekendTimes.add(xyz.weekend.fromCampus[i]);
                  }
                }
                weekendTimes.sort((a, b) => a.compareTo(b));
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      mapStore.selectedCarousel(index);
                      mapStore.zoomTwoMarkers(
                          LatLng(
                              mapStore.allLocationData[
                                  mapStore.selectedCarouselIndex]['lat'],
                              mapStore.allLocationData[
                                  mapStore.selectedCarouselIndex]['long']),
                          LatLng(mapStore.userlat, mapStore.userlong),
                          100.0);
                    },
                    child: Observer(builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          color: kTileBackground,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                              color: (mapStore.selectedCarouselIndex == index)
                                  ? lBlue5
                                  : kTileBackground),
                        ),
                        child: ListTile(
                            textColor: kWhite,
                            leading: const CircleAvatar(
                              backgroundColor: lYellow2,
                              radius: 26,
                              child: Icon(
                                FluentIcons.vehicle_bus_24_filled,
                                color: kBlueGrey,
                              ),
                            ),
                            title: Text(
                              mapStore.allLocationData[index]['name'],
                              style: MyFonts.w500.setColor(kWhite),
                            ),
                            subtitle: Text(
                                "${calculateDistance(
                                  mapStore.userLatLng,
                                  LatLng(mapStore.allLocationData[index]['lat'],
                                      mapStore.allLocationData[index]['long']),
                                ).toStringAsFixed(2)} km",
                                style: MyFonts.w500.setColor(kGrey13)),
                            trailing: Text(
                              (getFormattedDay() == 'Fri')
                                  ? nextTime(weekendTimes,
                                      firstTime: weekendTimes[0].toString())
                                  : (getFormattedDay() == 'Sun')
                                      ? nextTime(weekendTimes,
                                          firstTime:
                                              weekdaysTimes[0].toString())
                                      : (getFormattedDay() == 'Sat')
                                          ? nextTime(weekendTimes)
                                          : nextTime(weekdaysTimes),
                              style: MyFonts.w500.setColor(lBlue2),
                            )),
                      );
                    }),
                  ),
                );
              }
              return ListShimmer();
            },
          );
        });
  }
}
