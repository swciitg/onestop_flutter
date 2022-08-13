import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart' as Launch;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/widgets/mapbox/carousel_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class MapBox extends StatefulWidget {
  MapBox({
    Key? key,
  }) : super(key: key);

  @override
  State<MapBox> createState() => _MapBoxState();
}

DateTime now = DateTime.now();
String formattedTime = DateFormat.jm().format(now);

class _MapBoxState extends State<MapBox> {
  String mapString = '';
  late GoogleMapController controller;
  final pointIcon = 'assets/images/pointicon.png';
  final busIcon = 'assets/images/busicon.png';

  double zoom = 13.0;

  @override
  void initState() {
    super.initState();
    rootBundle
        .loadString('assets/json/map_style.json')
        .then((value) => mapString = value);
  }

  @override
  void dispose() {
    // context.read<MapBoxStore>().mapController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      var mapbox_store = context.read<MapBoxStore>();
      print("rebuildMap Box");
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: [
            FutureBuilder(
                future: mapbox_store.getLocation(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Observer(builder: (context) {
                      print("BUilder rebuild");
                      return Container(
                        height: 365,
                        width: double.infinity,
                        child: GoogleMap(
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>[
                            new Factory<OneSequenceGestureRecognizer>(
                                () => new EagerGestureRecognizer())
                          ].toSet(),
                          onMapCreated: (mapcontroller) {
                            controller = mapcontroller;
                            controller.setMapStyle(mapString);
                            mapbox_store.mapController = mapcontroller;
                          },
                          initialCameraPosition: CameraPosition(
                              target: snapshot.data as LatLng, zoom: 15),
                          markers: mapbox_store.markers.toSet(),
                          // polylines: poly.toSet(),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          compassEnabled: true,
                          trafficEnabled: true,
                          zoomControlsEnabled: false,
                        ),
                      );
                    });
                  }
                  return Shimmer.fromColors(
                      child: Container(
                        height: 365,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: kBlack,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      period: Duration(seconds: 1),
                      baseColor: kHomeTile,
                      highlightColor: lGrey);
                }),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        mapbox_store.setIndexMapBox(0);
                        // mapbox_store.generate_bus_markers();
                      },
                      //padding: EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        child: Container(
                          height: 32,
                          width: 83,
                          color: (mapbox_store.indexBusesorFerry == 0)
                              ? lBlue2
                              : kBlueGrey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.vehicle_bus_24_regular,
                                color: (mapbox_store.indexBusesorFerry == 0)
                                    ? kBlueGrey
                                    : kWhite,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "Bus",
                                  style: (mapbox_store.indexBusesorFerry == 0)
                                      ? MyFonts.w500.setColor(kBlueGrey)
                                      : MyFonts.w500.setColor(kWhite),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        mapbox_store.setIndexMapBox(1);
                      },
                      //padding: EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        child: Container(
                          height: 32,
                          width: 83,
                          color: (mapbox_store.indexBusesorFerry == 1)
                              ? lBlue2
                              : kBlueGrey,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.vehicle_ship_24_regular,
                                color: (mapbox_store.indexBusesorFerry == 1)
                                    ? kBlueGrey
                                    : kWhite,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text("Ferry",
                                    style: (mapbox_store.indexBusesorFerry == 1)
                                        ? MyFonts.w500.setColor(kBlueGrey)
                                        : MyFonts.w500.setColor(kWhite)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*(!mapbox_store.isTravelPage)
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                mapbox_store.setIndexMapBox(2);
                                mapbox_store.generate_restaraunt_markers();
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              child: Container(
                                height: 32,
                                width: 83,
                                color: (mapbox_store.indexBusesorFerry == 2)
                                    ? lBlue2
                                    : kBlueGrey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bus_alert,
                                      color:
                                          (mapbox_store.indexBusesorFerry == 2)
                                              ? kBlueGrey
                                              : kWhite,
                                    ),
                                    Text("Food",
                                        style: (mapbox_store
                                                    .indexBusesorFerry ==
                                                2)
                                            ? MyFonts.w500.setColor(kBlueGrey)
                                            : MyFonts.w500.setColor(kWhite)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),*/
                  ],
                ),
                SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4, bottom: 8),
                          child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: kAppBarGrey,
                            onPressed: () async {
                              await Launch.MapLauncher.showMarker(
                                coords: Launch.Coords(37.759392, -122.5107336),
                                title: "Ocean Beach", mapType: Launch.MapType.google,
                              );
                            },
                            child: Icon(
                              FluentIcons.directions_24_regular,
                              color: lBlue2,
                            ),
                            mini: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, right: 4),
                          child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: kAppBarGrey,
                            onPressed: () {
                              // _mapController.
                              // moveAndRotate(
                              //     LatLng(mapbox_store.userlat,
                              //         mapbox_store.userlong),
                              //     15,
                              //     17);
                              zoomInMarker(
                                  mapbox_store.userlat, mapbox_store.userlong);
                            },
                            child: Icon(
                              FluentIcons.my_location_24_regular,
                              color: lBlue2,
                            ),
                            mini: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                (!mapbox_store.isTravelPage)
                    ? Observer(
                      builder: (context) {
                        print("carousel rebuild");
                        print("${mapbox_store.carouselCards.toString()}");
                        return CarouselSlider(
                            items: mapbox_store.carouselCards
                                .map((e) => GestureDetector(
                                      child: mapbox_store
                                                  .selectedCarouselIndex ==
                                              (e as CarouselCard).index
                                          ? e
                                          : ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.grey.shade600,
                                                  BlendMode.modulate),
                                              child: e,
                                            ),
                                      onTap: () {
                                        mapbox_store.selectedCarousel(
                                            (e as CarouselCard).index);
                                        mapbox_store.zoomTwoMarkers(
                                            // LatLng(
                                            //     mapbox_store.bus_carousel_data[
                                            //             mapbox_store
                                            //                 .selectedCarouselIndex]
                                            //         ['lat'],
                                            //     mapbox_store.bus_carousel_data[
                                            //             mapbox_store
                                            //                 .selectedCarouselIndex]
                                            //         ['long']),
                                          mapbox_store.selectedCarouselLatLng,
                                            LatLng(mapbox_store.userlat,
                                                mapbox_store.userlong),
                                            120.0);
                                      },
                                    ))
                                .toList(),
                            options: CarouselOptions(
                              height: 100,
                              viewportFraction: 0.7,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              scrollDirection: Axis.horizontal,
                              // onPageChanged:
                              //     (int index, CarouselPageChangedReason reason) async {
                              //
                              // },
                            ),
                          );
                      }
                    )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      );
    });
  }

  void zoomInMarker(double lat, double long) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 17.0, bearing: 90.0, tilt: 45.0)));
  }
}
