import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/mapbox/mapBox.dart';
import 'package:onestop_dev/widgets/travel/bus_details.dart';
import 'package:onestop_dev/widgets/travel/bus_list.dart';
import 'package:onestop_dev/widgets/travel/ferry_details.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);
  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  int selectBusesorStops = 0;

  @override
  Widget build(BuildContext context) {
    var map_store = context.read<MapBoxStore>();
    map_store.checkTravelPage(true);
      return SingleChildScrollView(
        child: Column(
          children: [
            MapBox(),
            SizedBox(
              height: 10,
            ),
            Provider<TravelStore>(create: (_) => TravelStore(), builder: (context, _) {
              return Observer(builder: (context) {
                return (map_store.indexBusesorFerry == 0)
                    ? BusList()
                    : FerryDetails();
              });
            },)
          ],
        ),
      );
  }


}
