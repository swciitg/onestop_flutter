import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

class BusStopList extends StatelessWidget {
  const BusStopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: context.read<MapBoxStore>().bus_carousel_data.length,
        itemBuilder: (BuildContext context, int index) {
          var map_store = context.read<MapBoxStore>();
          return Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: GestureDetector(
              onTap: () {
                map_store.selectedCarousel(index);
                map_store.zoomTwoMarkers(
                  LatLng(
                      map_store.bus_carousel_data[
                          map_store.selectedCarouselIndex]['lat'],
                      map_store.bus_carousel_data[
                          map_store.selectedCarouselIndex]['long']),
                  LatLng(map_store.userlat, map_store.userlong),
                );
              },
              child: Observer(builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: kTileBackground,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        color: (map_store.selectedCarouselIndex == index)
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
                      map_store.bus_carousel_data[index]['name'],
                      style: MyFonts.w500.setColor(kWhite),
                    ),
                    subtitle: Text(
                        map_store.bus_carousel_data[index]['distance']
                                .toString() +
                            " km",
                        style: MyFonts.w500
                            .setColor(kGrey13)),
                    trailing: (map_store.bus_carousel_data[index]['status'] ==
                            'left')
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Left',
                                style: MyFonts.w500
                                    .setColor(Color.fromRGBO(135, 145, 165, 1)),
                              ),
                              Text(
                                map_store.bus_carousel_data[index]['time'],
                                style: MyFonts.w500
                                    .setColor(Color.fromRGBO(195, 198, 207, 1)),
                              ),
                            ],
                          )
                        : Text(
                            map_store.bus_carousel_data[index]['time'],
                            style: MyFonts.w500.setColor(lBlue2),
                          ),
                  ),
                );
              }),
            ),
          );
        });
  }
}
