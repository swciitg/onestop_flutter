import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

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
  final MapController _mapController = MapController();
  final myToken =
      'pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg';
  final pointIcon = 'assets/images/pointicon.png';
  final busIcon = 'assets/images/busicon.png';

  double zoom = 13.0;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      var mapbox_store = context.read<MapBoxStore>();
      mapbox_store.checkTravelPage(true);
      Future.delayed(Duration(seconds: 10), mapbox_store.getLocation);
      mapbox_store.change_centre_zoom(
          mapbox_store.userlat, mapbox_store.userlong);
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: [
            Container(
              height: 365,
              // width: 350,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: mapbox_store.myPos,
                  zoom: zoom,
                ),
                nonRotatedLayers: [
                  TileLayerOptions(
                    backgroundColor: kBlack,
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/mapbox/dark-v10/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg',
                    additionalOptions: {
                      'accessToken': myToken,
                      'id': 'mapbox/light-v10',
                    },
                  ),
                  MarkerLayerOptions(
                    markers: mapbox_store.markers,
                  ),
                  if(mapbox_store.loadOperation.value!=null)
                    PolylineLayerOptions(polylines: [
                      Polyline(
                        points: mapbox_store.loadOperation.value!,
                        // isDotted: true,
                        color: Color(0xFF669DF6),
                        strokeWidth: 3.0,
                        borderColor: Color(0xFF1967D2),
                        borderStrokeWidth: 0.1,
                      )
                    ]),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        mapbox_store.setIndexMapBox(0);
                        mapbox_store.generate_bus_markers();
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
                                IconData(0xe1d5, fontFamily: 'MaterialIcons'),
                                color: (mapbox_store.indexBusesorFerry == 0)
                                    ? kBlueGrey
                                    : kWhite,
                              ),
                              Text(
                                "Bus",
                                style: TextStyle(
                                  color: (mapbox_store.indexBusesorFerry == 0)
                                      ? kBlueGrey
                                      : kWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          mapbox_store.setIndexMapBox(1);
                        });
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
                                IconData(0xefc2, fontFamily: 'MaterialIcons'),
                                color: (mapbox_store.indexBusesorFerry == 1)
                                    ? kBlueGrey
                                    : kWhite,
                              ),
                              Text(
                                "Ferry",
                                style: TextStyle(
                                  color: (mapbox_store.indexBusesorFerry == 1)
                                      ? kBlueGrey
                                      : kWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    (mapbox_store.isTravelPage)
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
                                    Text(
                                      "Food",
                                      style: TextStyle(
                                        color:
                                            (mapbox_store.indexBusesorFerry ==
                                                    2)
                                                ? kBlueGrey
                                                : kWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
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
                            onPressed: () {},
                            child: Icon(Icons.navigate_before_outlined),
                            mini: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, right: 4),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              _mapController.moveAndRotate(
                                  LatLng(mapbox_store.userlat,
                                      mapbox_store.userlong),
                                  15,
                                  17);
                            },
                            child: Icon(Icons.my_location),
                            mini: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                (mapbox_store.isTravelPage)
                    ? CarouselSlider(
                        items: mapbox_store.buses_carousel,
                        options: CarouselOptions(
                          height: 100,
                          viewportFraction: 0.6,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          scrollDirection: Axis.horizontal,
                          // onPageChanged:
                          //     (int index, CarouselPageChangedReason reason) async {
                          //
                          // },
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      );
    });
  }
}

//
