import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
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
  Map<String, List<List<String>>> busTime = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DataProvider.getBusTimings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            busTime = snapshot.data as Map<String, List<List<String>>>;
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
                      isCity? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                ),
                isCity
                    ? Column(
                        children: busTime.entries.map((entry) {
                        if ((busTime[entry.key]![widget.index].isEmpty)) {
                          return Container();
                        }
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "To ${entry.key}",
                                style: MyFonts.w500.setColor(kWhite),
                              ),
                            ),
                            Column(
                                children:
                                    busTime[entry.key]![widget.index].map((e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: TimingTile(
                                  time: e,
                                  isLeft: hasLeft(e.toString()),
                                  icon: FluentIcons.vehicle_bus_24_filled,
                                ),
                              );
                            }).toList()),
                          ],
                        );
                      }).toList())
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
                      isCampus? Icons.arrow_drop_up :Icons.arrow_drop_down ,
                      color: Colors.white,
                    ),
                  ),
                ),
                isCampus
                    ? Column(
                        children: busTime.entries.map((entry) {
                        if ((busTime[entry.key]![widget.index + 2].isEmpty)) {
                          return Container();
                        }
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "From ${entry.key}",
                                style: MyFonts.w500.setColor(kWhite),
                              ),
                            ),
                            Column(
                                children: busTime[entry.key]![widget.index + 2]
                                    .map((e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: TimingTile(
                                  time: e,
                                  isLeft: hasLeft(e.toString()),
                                  icon: FluentIcons.vehicle_bus_24_filled,
                                ),
                              );
                            }).toList()),
                          ],
                        );
                      }).toList())
                    : Container(),
              ],
            );
          }
          return ListShimmer(count: 2);
        });
  }
}
