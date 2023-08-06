import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/timing_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';

class BusDetails extends StatefulWidget {
  late final int index;
  // ignore: prefer_const_constructors_in_immutables
  BusDetails({Key? key, required this.index}) : super(key: key);

  @override
  State<BusDetails> createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  bool isCity = false;
  bool isCampus = false;
  List<TravelTiming>? busTime = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = context.read<TravelStore>();
    var daytype = store.busDayType;
    return FutureBuilder<List<TravelTiming>>(
        future: store.getBusTimings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            busTime = snapshot.data;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCity = !isCity;
                      isCampus = false;
                    });
                  },
                  child: ListTile(
                    title: Text(
                      'Campus -> City',
                      style: MyFonts.w500.setColor(kWhite),
                    ),
                    subtitle: Text(
                      'Starting from Biotech park',
                      style: MyFonts.w500.setColor(Colors.grey),
                    ),
                    trailing: Icon(
                      isCity
                          ? FluentIcons.chevron_up_24_regular
                          : FluentIcons.chevron_down_24_regular,
                      color: Colors.white,
                    ),
                  ),
                ),
                isCity
                    ?ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount:busTime!.length,
                      itemBuilder: (context, int idx) {
                        return Column(
                  children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "To ${busTime![idx].stop}",
                            style: MyFonts.w500.setColor(kWhite),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount:daytype == 'Weekdays' ?busTime![idx].weekdays.fromCampus.length:busTime![idx].weekend.fromCampus.length,
                            itemBuilder:(BuildContext context, int index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: TimingTile(
                                  time:  daytype == 'Weekdays' ? formatTime(busTime![idx].weekdays.fromCampus[index]):formatTime(busTime![idx].weekend.fromCampus[index]),
                                  isLeft: daytype=='Weekdays'?   hasLeft(busTime![idx].weekdays.fromCampus[index]):hasLeft(busTime![idx].weekend.fromCampus[index]),
                                  icon: FluentIcons.vehicle_bus_24_filled,

                                ),
                              );
                            }
                        ),
                  ],
                );
                      }
                    )
                    : Container(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCampus = !isCampus;
                      isCity = false;
                    });
                  },
                  child: ListTile(
                    title: Text(
                      'City -> Campus',
                      style: MyFonts.w500.setColor(kWhite),
                    ),
                    subtitle: Text(
                      'Starting from City',
                      style: MyFonts.w500.setColor(Colors.grey),
                    ),
                    trailing: Icon(
                      isCampus
                          ? FluentIcons.chevron_up_24_regular
                          : FluentIcons.chevron_down_24_regular,
                      color: Colors.white,
                    ),
                  ),
                ),
                isCampus
                    ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount:busTime!.length,
                      itemBuilder: (context, idx) {
                        return Column(
                  children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "From ${busTime![idx].stop}",
                            style: MyFonts.w500.setColor(kWhite),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount:daytype == 'Weekdays' ?busTime![idx].weekdays.toCampus.length : busTime![idx].weekend.toCampus.length,
                            itemBuilder:(BuildContext context, int index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: TimingTile(
                                  time:  daytype == 'Weekdays' ? formatTime(busTime![idx].weekdays.toCampus[index]):formatTime(busTime![idx].weekend.toCampus[index]),
                                  isLeft: daytype=='Weekdays'?hasLeft(busTime![idx].weekdays.toCampus[index]):hasLeft(busTime![idx].weekend.toCampus[index]),
                                  icon: FluentIcons.vehicle_bus_24_filled,

                                ),
                              );
                            }
                        ),
                  ],
                );
                      }
                    )
                    : Container(),
              ],
            );
          }
          return ListShimmer(count: 2);
        });
  }
}
