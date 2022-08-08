import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
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
  // final MapController _mapController = MapController();
  late GoogleMapController _mapController;
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
      mapbox_store.change_centre_zoom(
          mapbox_store.userlat, mapbox_store.userlong);
      // zoomTwoMarkers(LatLng(mapbox_store.carousel_selected_lat, mapbox_store.carousel_selected_long),LatLng(mapbox_store.userlat,mapbox_store.userlong));
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: [
            // Container(
            //   height: 365,
            //   // width: 350,
            //   child: FlutterMap(
            //     mapController: _mapController,
            //     options: MapOptions(
            //       center: mapbox_store.myPos,
            //       zoom: zoom,
            //     ),
            //     nonRotatedLayers: [
            //       TileLayerOptions(
            //         backgroundColor: kBlack,
            //         urlTemplate:
            //             'https://api.mapbox.com/styles/v1/mapbox/dark-v10/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg',
            //         additionalOptions: {
            //           'accessToken': myToken,
            //           'id': 'mapbox/light-v10',
            //         },
            //       ),
            //       MarkerLayerOptions(
            //         markers: mapbox_store.markers,
            //       ),
            //       if(mapbox_store.loadOperation.value!=null)
            //         PolylineLayerOptions(polylines: [
            //           Polyline(
            //             points: mapbox_store.loadOperation.value!,
            //             // isDotted: true,
            //             color: Color(0xFF669DF6),
            //             strokeWidth: 3.0,
            //             borderColor: Color(0xFF1967D2),
            //             borderStrokeWidth: 0.1,
            //           )
            //         ]),
            //     ],
            //   ),
            // ),
            FutureBuilder(
                future: mapbox_store.getLocation(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 365,
                      width: double.infinity,
                      child: GoogleMap(
                        onMapCreated: onMapCreate,
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
                  } else {
                    return ListShimmer(
                      height: 20,
                      count: 1,
                    );
                  }
                }),
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
                    (!mapbox_store.isTravelPage)
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
                              // _mapController.
                              // moveAndRotate(
                              //     LatLng(mapbox_store.userlat,
                              //         mapbox_store.userlong),
                              //     15,
                              //     17);
                              zoomInMarker(
                                  mapbox_store.userlat, mapbox_store.userlong);
                            },
                            child: Icon(Icons.my_location),
                            mini: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                (!mapbox_store.isTravelPage)
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

  void onMapCreate(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void zoomInMarker(double lat, double long) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 17.0, bearing: 90.0, tilt: 45.0)));
  }
  void zoomTwoMarkers(LatLng ans,LatLng user) async {
    double startLatitude = user.latitude;
    double startLongitude = user.longitude;

    double destinationLatitude = ans.latitude;
    double destinationLongitude = ans.longitude;
    double miny = (startLatitude <= destinationLatitude)
        ? startLatitude
        : destinationLatitude;
    double minx = (startLongitude <= destinationLongitude)
        ? startLongitude
        : destinationLongitude;
    double maxy = (startLatitude <= destinationLatitude)
        ? destinationLatitude
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude)
        ? destinationLongitude
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
  }
  //
  // late PolylinePoints polylinePoints;
  // List<LatLng> polylineCoordinates = [];
  //
  // _createPolylines(double startlat, double startlong, double destlat,
  //     double destlong) async {
  //   polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     api_key,
  //     PointLatLng(startlat, startlong),
  //     PointLatLng(destlat, destlong),
  //     travelMode: TravelMode.transit,
  //   );
  //
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }
  //
  //   PolylineId id = PolylineId('poly');
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.blue,
  //     points: polylineCoordinates,
  //     width: 3,
  //   );
  //   setState(() {
  //     poly.add(polyline);
  //   });
  // }
}

//
