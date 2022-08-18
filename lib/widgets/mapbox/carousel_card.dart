import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/functions/travel/check_weekday.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

class CarouselCard extends StatelessWidget {
  final String name;
  final int index;

  CarouselCard(
      {Key? key, required this.index, required this.name})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    Future<String> getNextTime()async {
      print('next time function');
      if(context.read<MapBoxStore>().indexBusesorFerry == 0)
        {
          var busTimes = await DataProvider.getBusTimings();
          if(checkWeekday())
          {
            return 'Next Bus at: '+nextTime(busTimes[1]);
          }
          else
          {
            return 'Next Bus at: '+nextTime(busTimes[0]);
          }
        }
      else
        {
          var ferryTimes = await DataProvider.getFerryTimings();
          var requiredModel = ferryTimes.firstWhere((element) => element.name == this.name);
          if(checkWeekday())
          {
            return 'Next Ferry at: '+nextTime(requiredModel.MonToFri_NorthGuwahatiToGuwahati);
          }
          else {
            return 'Next Ferry at: '+nextTime(requiredModel.Sunday_NorthGuwahatiToGuwahati);
          }
        }
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 3.0, right: 3),
      child: Observer(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(34, 36, 41, 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                SizedBox(
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
                      SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: getNextTime(),
                        builder: (context,snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data! as String,
                              style: MyFonts.w500.size(11).setColor(kGrey13),
                            );
                          }
                          return Container();
                        }
                      ),
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
