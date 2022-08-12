import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'bus_tile.dart';

class BusDetails extends StatefulWidget {
  late int index;
  BusDetails({Key? key, required this.index}) : super(key: key);

  @override
  State<BusDetails> createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  bool isCity = false;
  bool isCampus = false;
  List<List<String>> busTime = [];

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
            busTime = snapshot.data as List<List<String>>;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCity = !isCity;
                    });
                  },
                  child: Container(
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
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                isCity
                    ? Column(
                        children: busTime[widget.index].map((e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: BusTile(
                            time: e,
                            isLeft: hasLeft(e.toString()),
                          ),
                        );
                      }).toList())
                    : Container(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCampus = !isCampus;
                    });
                  },
                  child: Container(
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
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                isCampus
                    ? Column(
                        children: busTime[widget.index + 2].map((e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: BusTile(
                            time: e,
                            isLeft: hasLeft(e.toString()),
                          ),
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
