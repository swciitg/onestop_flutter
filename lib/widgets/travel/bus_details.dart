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
  final int index;
  BusDetails({Key? key, required this.index}) : super(key: key);

  @override
  State<BusDetails> createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  bool isCity = false;
  bool isCampus = false;

  @override
  Widget build(BuildContext context) {
    var store = context.read<TravelStore>();
    var daytype = store.busDayType;

    Widget buildTimingList(List<TravelTiming> busTimings, String dayType, bool isFromCampus) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: busTimings.length,
        itemBuilder: (context, idx) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  isFromCampus ? "To ${busTimings[idx].stop}" : "From ${busTimings[idx].stop}",
                  style: MyFonts.w500.setColor(kWhite),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: isFromCampus
                    ? (dayType == 'Weekdays' 
                        ? busTimings[idx].weekdays.fromCampus.length
                        : busTimings[idx].weekend.fromCampus.length)
                    : (dayType == 'Weekdays'
                        ? busTimings[idx].weekdays.toCampus.length
                        : busTimings[idx].weekend.toCampus.length),
                itemBuilder: (BuildContext context, int index) {
                  final time = isFromCampus
                      ? (dayType == 'Weekdays'
                          ? formatTime(busTimings[idx].weekdays.fromCampus[index])
                          : formatTime(busTimings[idx].weekend.fromCampus[index]))
                      : (dayType == 'Weekdays'
                          ? formatTime(busTimings[idx].weekdays.toCampus[index])
                          : formatTime(busTimings[idx].weekend.toCampus[index]));
                  final isLeft = dayType == 'Weekdays'
                      ? hasLeft(isFromCampus
                          ? busTimings[idx].weekdays.fromCampus[index]
                          : busTimings[idx].weekdays.toCampus[index])
                      : hasLeft(isFromCampus
                          ? busTimings[idx].weekend.fromCampus[index]
                          : busTimings[idx].weekend.toCampus[index]);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TimingTile(
                      time: time,
                      isLeft: isLeft,
                      icon: FluentIcons.vehicle_bus_24_filled,
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<List<TravelTiming>>(
      future: store.getBusTimings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final busTime = snapshot.data!;
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
              isCity ? buildTimingList(busTime, daytype, true) : Container(),
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
              isCampus ? buildTimingList(busTime, daytype, false) : Container(),
            ],
          );
        }
        return ListShimmer(count: 2);
      },
    );
  }
}
