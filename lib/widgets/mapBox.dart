import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:onestop_dev/globals.dart';

import '../globals/my_colors.dart';

class MapBox extends StatefulWidget {
  Function? rebuildParent;
  double? lat, long;
  int? selectedIndex;
  final bool istravel;

  MapBox(
      {Key? key,
      this.lat,
      this.long,
      this.selectedIndex,
      this.rebuildParent,
      required this.istravel})
      : super(key: key);

  @override
  State<MapBox> createState() => _MapBoxState();
}

bool status = false;
DateTime now = DateTime.now();
String formattedTime = DateFormat.jm().format(now);

class _MapBoxState extends State<MapBox> {
  final MapController _mapController = MapController();
  bool mapToggle = true;
  final myToken =
      'pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg';
  final pointIcon = 'assets/images/pointicon.png';
  final busIcon = 'assets/images/busicon.png';
  late LatLng myPos = LatLng(-37.327154, -59.119667);
  double zoom = 13.0;
  List<LatLng> latlngList = [];

  void initState() {
    super.initState();
    _getLoctaion();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 10), _getLoctaion);
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
                center: myPos,
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
                  markers: markers,
                ),
                PolylineLayerOptions(polylines: [
                  Polyline(
                    points: [
                      LatLng(lat, long),
                      (widget.lat != null && widget.lat != null)
                          ? LatLng(widget.lat!, widget.long!)
                          : LatLng(lat, long),
                    ],
                    // isDotted: true,
                    color: Color(0xFF669DF6),
                    strokeWidth: 3.0,
                    borderColor: Color(0xFF1967D2),
                    borderStrokeWidth: 0.1,
                  )
                ])
              ],
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    widget.rebuildParent!(0);
                  },
                  //padding: EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: Container(
                      height: 32,
                      width: 83,
                      color: (widget.selectedIndex == 0) ? lBlue2 : kBlueGrey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(0xe1d5, fontFamily: 'MaterialIcons'),
                            color: (widget.selectedIndex == 0)
                                ? kBlueGrey
                                : kWhite,
                          ),
                          Text(
                            "Bus",
                            style: TextStyle(
                              color: (widget.selectedIndex == 0)
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
                      widget.rebuildParent!(1);
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
                      color: (widget.selectedIndex == 1) ? lBlue2 : kBlueGrey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(0xefc2, fontFamily: 'MaterialIcons'),
                            color: (widget.selectedIndex == 1)
                                ? kBlueGrey
                                : kWhite,
                          ),
                          Text(
                            "Ferry",
                            style: TextStyle(
                              color: (widget.selectedIndex == 1)
                                  ? kBlueGrey
                                  : kWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (widget.istravel)
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            widget.rebuildParent!(2);
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: Container(
                            height: 32,
                            width: 83,
                            color: (widget.selectedIndex == 2)
                                ? lBlue2
                                : kBlueGrey,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bus_alert,
                                  color: (widget.selectedIndex == 2)
                                      ? kBlueGrey
                                      : kWhite,
                                ),
                                Text(
                                  "Food",
                                  style: TextStyle(
                                    color: (widget.selectedIndex == 2)
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
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      MapsLauncher.launchCoordinates(
                          (widget.lat != null) ? widget.lat! : lat,
                          (widget.long != null) ? widget.long! : long);
                    },
                    child: Icon(Icons.navigate_before_outlined),
                    mini: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      _mapController.moveAndRotate(LatLng(lat, long), 15, 17);
                    },
                    child: Icon(Icons.my_location),
                    mini: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Location location = new Location();
  LocationData? _locationData;
  double lat = 0;
  double long = 0;
  List<Marker> markers = [];
  Future<dynamic> _getLoctaion() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    _addMarker(
        _locationData!.latitude!,
        _locationData!.longitude!,
        (widget.lat != null) ? widget.lat! : lat,
        (widget.long != null) ? widget.long! : long);
    setState(() {
      lat = _locationData!.latitude!;
      long = _locationData!.longitude!;
      userlat = _locationData!.latitude!;
      userlong = _locationData!.longitude!;
      mapToggle = true;
    });
    _mapController.moveAndRotate(LatLng(userlat, userlong), 15, 17);
  }

  void _addMarker(double userlat, double userlong, double lat, double long) {
    Marker? marker;
    if (userlat == lat) {
      marker = Marker(
        point: LatLng(userlat, userlong),
        width: 25.0,
        height: 25.0,
        builder: (ctx) => Container(
          child: Image.asset(pointIcon),
        ),
      );
      return;
    }
    Marker marker2 = Marker(
      point: LatLng(lat, long),
      width: 25.0,
      height: 25.0,
      builder: (ctx) => Container(
        child: Image.asset(busIcon),
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker!);
      markers.add(marker2);
    });
  }
}
