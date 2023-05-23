import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';
import '../../functions/travel/next_time.dart';
import '../../stores/travel_store.dart';
import 'timing_tile.dart';

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
    var daytype = context.read<TravelStore>().busDayType;
    return FutureBuilder<List<TravelTiming>>(
        future: APIService.getBusTiming(),
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
                    ?Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "To ${busTime![0].stop}",
                        style: MyFonts.w500.setColor(kWhite),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount:daytype == 'Weekdays' ?busTime![0].weekdays.fromCampus.length:busTime![0].weekend.fromCampus.length,
                        itemBuilder:(BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TimingTile(
                              time:  daytype == 'Weekdays' ? formatTime(busTime![0].weekdays.fromCampus[index]):formatTime(busTime![0].weekend.fromCampus[index]),
                              isLeft: daytype=='Weekdays'?   hasLeft(busTime![0].weekdays.fromCampus[index]):hasLeft(busTime![0].weekend.fromCampus[index]),
                              icon: FluentIcons.vehicle_bus_24_filled,

                            ),
                          );
                        }
                    ),
                  ],
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
                    ? Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "From ${busTime![0].stop}",
                        style: MyFonts.w500.setColor(kWhite),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount:daytype == 'Weekdays' ?busTime![0].weekdays.toCampus.length : busTime![0].weekend.toCampus.length,
                        itemBuilder:(BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TimingTile(
                              time:  daytype == 'Weekdays' ? formatTime(busTime![0].weekdays.toCampus[index]):formatTime(busTime![0].weekend.toCampus[index]),
                              isLeft: daytype=='Weekdays'?hasLeft(busTime![0].weekdays.toCampus[index]):hasLeft(busTime![0].weekend.toCampus[index]),
                              icon: FluentIcons.vehicle_bus_24_filled,

                            ),
                          );
                        }
                    ),
                  ],
                )
                    : Container(),
              ],
            );
          }
          return ListShimmer(count: 2);
        });
  }
}
