import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final MapController _mapController = MapController();
  bool mapToggle = true;
  final myToken =
      'pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg';
  final pointIcon = 'assets/custom-icon.png';
  late LatLng myPos = LatLng(-37.327154, -59.119667);
  double zoom = 13.0;
  void initState() {
    super.initState();
    _getLoctaion();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: myPos,
          zoom: zoom,
        ),
        nonRotatedLayers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/light-v10/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg',
            additionalOptions: {
              'accessToken': myToken,
              'id': 'mapbox/light-v10',
            },
          ),
          MarkerLayerOptions(
            markers: markers,
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
    _addMarker(_locationData!.latitude!, _locationData!.longitude!);
    setState(() {
      lat = _locationData!.latitude!;
      long = _locationData!.longitude!;
      mapToggle = true;
    });
  }

  void _addMarker(double lat, double long) {
    Marker marker = Marker(
      point: LatLng(lat, long),
      width: 25.0,
      height: 25.0,
      builder: (ctx) => Container(
        child: Image.asset(pointIcon),
      ),
    );
    setState(() {
      markers.add(marker);
    });
  }
}
