import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/pages/travel/data.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/widgets/mapbox/carousel_card.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
part 'mapbox_store.g.dart';

class MapBoxStore = _MapBoxStore with _$MapBoxStore;

abstract class _MapBoxStore with Store {
  _MapBoxStore() {
    initialiseCarouselforBuses();
  }
  GoogleMapController? mapController;
  @observable
  int indexBusesorFerry = 0;
  @observable
  double userlat = 0;
  @observable
  double userlong = 0;
  @observable
  int selectedCarouselIndex = 0;
  @observable
  bool isTravelPage = false;
  @observable
  LatLng myPos = LatLng(-37.327154, -59.119667);
  @observable
  List<Map> bus_carousel_data = [];
  @observable
  late List<Widget> bus_carousel_items;
  @observable
  late List<Polyline> bus_stop_polylines;
  @observable
  ObservableFuture<List<LatLng>?> loadOperation = ObservableFuture.value(null);

  @observable
  ObservableList<Marker> markers = ObservableList<Marker>.of([]);

  @action
  void setMarkers(List<Marker> m) {
    print("Setting markers");
    this.markers = ObservableList<Marker>.of(m);
  }

  @action
  void setIndexMapBox(int i) {
    this.indexBusesorFerry = i;
  }

  @action
  void change_centre_zoom(double lat, double long) {
    this.myPos = LatLng(lat, long);
  }

  @action
  void setUserLatLng(double lat, double long) {
    this.userlat = lat;
    this.userlong = long;
  }

  @action
  void selectedCarousel(int i) {
    this.selectedCarouselIndex = i;
    getBytesFromAsset('assets/images/busicon.png', 100).then((d) {
      List<Marker> l = [];
      l.add(Marker(
          icon: BitmapDescriptor.fromBytes(d),
          markerId: MarkerId('bus$i'),
          position: LatLng(this.bus_carousel_data[i]['lat'],
              this.bus_carousel_data[i]['long'])));
      setMarkers(l);
    }) ;
  }

  @action
  void checkTravelPage(bool i) {
    this.isTravelPage = i;
  }

  @action
  Future<void> getPolylines(int i) async {
    print("Call API for timetable ${loadOperation.status}");
    loadOperation = APIService.getPolyline(
            source: LatLng(this.userlat, this.userlong),
            dest: LatLng(26.2027, 91.7004))
        .asObservable();
    print(loadOperation.value);
  }

  @action
  void initialiseCarouselforBuses() {
    for (int index = 0; index < BusStops.length; index++) {
      this.bus_carousel_data.add({
        'index': index,
        'time': BusStops[index]['time'],
        'lat': BusStops[index]['lat'],
        'long': BusStops[index]['long'],
        'status': BusStops[index]['status'],
        'distance': BusStops[index]['distance'],
        'name': BusStops[index]['name']
      });
    }
    bus_carousel_data.sort((a, b) => a['distance'] < b['distance'] ? 0 : 1);
    generate_bus_markers();
    // generate_polylines();
  }

  @computed
  List<Widget> get buses_carousel {
    List<Widget> l = List<Widget>.generate(
      this.bus_carousel_data.length,
      (index) => CarouselCard(
          index: this.bus_carousel_data[index]['index'],
          time: this.bus_carousel_data[index]['time']),
    );
    return l;
  }

  // @computed
  // List<CameraPosition> get bus_camera_positions{
  //   // initialize map symbols in the same order as carousel widgets
  //   List<CameraPosition> kBusStopsList = List<CameraPosition>.generate(
  //       BusStops.length,
  //           (index) => CameraPosition(
  //           target: this.bus_carousel_data[index]['index'],
  //           zoom: 15),
  //   );
  //   return kBusStopsList;
  // }

  void zoomTwoMarkers(LatLng ans, LatLng user, double zoom) async {
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

    this.mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(northEastLatitude, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            ),
            zoom,
          ),
        );
  }

  // Location location = new Location();
  // LocationData? _locationData;
  //
  // Future<dynamic> getLocation() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   _locationData = await location.getLocation();
  //   this.userlat = _locationData!.latitude!;
  //   this.userlong = _locationData!.longitude!;
  //   return LatLng(this.userlat, this.userlong);
  //   // Marker user_marker = Marker(
  //   //   point: LatLng(this.userlat, this.userlong),
  //   //   width: 8,
  //   //   height: 8,
  //   //   builder: (ctx) => Container(
  //   //     child: Image.asset(pointIcon),
  //   //   ),
  //   // );
  //   // this.markers.add(user_marker);
  // }
  Future<dynamic> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos=await Geolocator.getCurrentPosition();
    this.userlat=pos.latitude;
    this.userlong=pos.longitude;
    return LatLng(pos.latitude, pos.longitude);
  }
  @action
  void generate_bus_markers() {
    print('generate bs');
    List<Marker> l = List.generate(
      this.bus_carousel_data.length,
      (index) => Marker(
          markerId: MarkerId('bus$index'),
          position: LatLng(this.bus_carousel_data[index]['lat'],
              this.bus_carousel_data[index]['long'])),
    );
    this.markers = ObservableList<Marker>.of(l);
  }

  @action
  void generate_restaraunt_markers() {
    List<Marker> l = List.generate(
      this.bus_carousel_data.length,
      (index) =>
          //     Marker(
          //   point: LatLng(this.bus_carousel_data[index]['lat'],
          //       this.bus_carousel_data[index]['long']),
          //   width: 25.0,
          //   height: 25.0,
          //   builder: (ctx) => Container(
          //     child: Image.asset(restaurauntIcon),
          //   ),
          // ),
          Marker(
              markerId: MarkerId('bus$index'),
              position: LatLng(this.bus_carousel_data[index]['lat'],
                  this.bus_carousel_data[index]['long'])),
    );
    this.markers = ObservableList<Marker>.of(l);
    ;
  }

//   @action
//   void generate_polylines() {
//     List<Polyline> l = List.generate(
//       this.bus_carousel_data.length,
//       (index) => Polyline(
//         points: ,
// // isDotted: true,
//         color: Color(0xFF669DF6),
//         strokeWidth: 3.0,
//         borderColor: Color(0xFF1967D2),
//         borderStrokeWidth: 0.1,
//       )),
//     );
//   }

  final pointIcon = 'assets/images/pointicon.png';
  final busIcon = 'assets/images/busicon.png';
  final restaurauntIcon = 'assets/images/restaurantIcon.png';
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}
// this.bus_carousel_data[i]['lat'], this.bus_carousel_data[i]['long']
