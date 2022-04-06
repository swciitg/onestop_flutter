import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

List<String> Buses = ['manas', 'disang'];
int _selectedIndex = 0;

class _MapState extends State<Map> {
  final MapController _mapController = MapController();
  final CarouselController _controller = CarouselController();
  bool mapToggle = true;
  final myToken =
      'pk.eyJ1IjoibGVhbmQ5NjYiLCJhIjoiY2t1cmpreDdtMG5hazJvcGp5YzNxa3VubyJ9.laphl_yeaw_9SUbcebw9Rg';
  final pointIcon = 'assets/images/Ellipse135.png';
  late LatLng myPos = LatLng(-37.327154, -59.119667);
  double zoom = 13.0;
  final List<Widget> Sliders = Buses!
      .map(
        (item) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            child: Row(
              children: [
                Container(
                  child: Image.asset('assets/images/Frame88.png'),
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      )
      .toList();
  void initState() {
    super.initState();
    _getLoctaion();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    location.onLocationChanged.listen((LocationData current) {
      setState(() {
        lat = current.latitude!;
        long = current.longitude!;
      });
    });
    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () {},
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bus_alert),
                      Text("Buses"),
                    ],
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bus_alert),
                      Text("Ferries"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            height: 365,
            width: 350,
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
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CarouselSlider(
                items: Sliders,
                options: CarouselOptions(enlargeCenterPage: true, height: 100),
                carouselController: _controller,
              ),
            ],
          ),
        ),
        Positioned(
          left: 285,
          top: 300,
          child: FloatingActionButton(
            onPressed: () {
              _mapController.moveAndRotate(LatLng(lat, long), 15, 17);
            },
            child: Icon(Icons.my_location),
          ),
        ),
      ],
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
