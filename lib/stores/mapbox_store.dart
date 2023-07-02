// ignore_for_file: library_private_types_in_public_api

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/pages/travel/data.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/widgets/mapbox/carousel_card.dart';

part 'mapbox_store.g.dart';

class MapBoxStore = _MapBoxStore with _$MapBoxStore;

abstract class _MapBoxStore with Store {
  _MapBoxStore() {
    generateAllMarkers();
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
  LatLng myPos = const LatLng(-37.327154, -59.119667);

  @observable
  late List<Polyline> busStopPolylines;

  @observable
  ObservableFuture<List<LatLng>?> loadOperation = ObservableFuture.value(null);

  @observable
  ObservableList<Marker> markers = ObservableList<Marker>.of([]);

  @action
  void setMarkers(List<Marker> m) {
    markers = ObservableList<Marker>.of(m);
  }

  @action
  void setIndexMapBox(int i) {
    if (indexBusesorFerry != i) {
      indexBusesorFerry = i;
      generateAllMarkers();
      mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(_bounds(markers.toSet()), 120));
    }
  }

  LatLngBounds _bounds(Set<Marker> markers) {
    return _createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  @action
  void generateAllMarkers() {
    List<Marker> l = List.generate(
      allLocationData.length,
      (index) => Marker(
          infoWindow: InfoWindow(title: allLocationData[index]['name']),
          markerId: MarkerId('bus$index'),
          position: LatLng(
              allLocationData[index]['lat'], allLocationData[index]['long'])),
    );
    markers = ObservableList<Marker>.of(l);
  }

  @action
  void changeCenterZoom(double lat, double long) {
    myPos = LatLng(lat, long);
  }

  @action
  void setUserLatLng(double lat, double long) {
    userlat = lat;
    userlong = long;
  }

  @action
  void selectedCarousel(int i) {
    // Avoid unnecessary rebuilds
    // Handle case: Store is just created, index = 0, and user clicks on 0
    if (selectedCarouselIndex != i || markers.length != 1) {
      selectedCarouselIndex = i;
      String name = 'busicon';
      if (indexBusesorFerry == 1) {
        name = 'ferry_marker';
      }
      getBytesFromAsset('assets/images/$name.png', 100).then((d) {
        List<Marker> l = [];
        l.add(Marker(
            infoWindow: InfoWindow(title: allLocationData[i]['name']),
            icon: BitmapDescriptor.fromBytes(d),
            markerId: MarkerId('bus$i'),
            position:
                LatLng(allLocationData[i]['lat'], allLocationData[i]['long'])));
        markers = ObservableList<Marker>.of(l);
      });
    }
  }

  @action
  void checkTravelPage(bool i) {
    isTravelPage = i;
  }

  @action
  Future<void> getPolylines(int i,BuildContext context) async {
    loadOperation = APIService().getPolyline(
            source: LatLng(userlat, userlong),
            dest: const LatLng(26.2027, 91.7004))
        .asObservable();
  }

  @computed
  List<Map<String, dynamic>> get allLocationData {
    List<Map<String, dynamic>> dataMap = [];
    switch (indexBusesorFerry) {
      case 0:
        dataMap = busStopsData;
        break;
      case 1:
        dataMap = ferryGhats;
        break;
      default:
        dataMap = [];
    }
    return dataMap;
  }

  @computed
  LatLng get selectedCarouselLatLng {
    var dataMap = allLocationData;
    return LatLng(dataMap[selectedCarouselIndex]['lat'],
        dataMap[selectedCarouselIndex]['long']);
  }

  @computed
  String get selectedCarouselName =>
      allLocationData[selectedCarouselIndex]['name'];

  @computed
  LatLng get userLatLng {
    return LatLng(userlat, userlong);
  }

  @computed
  List<Widget> get carouselCards {
    int carouselLength = 0;
    List<Map<String, dynamic>> dataMap;
    switch (indexBusesorFerry) {
      case 0:
        carouselLength = busStopsData.length;
        dataMap = busStopsData;
        break;
      case 1:
        carouselLength = ferryGhats.length;
        dataMap = ferryGhats;
        break;
      default:
        carouselLength = 0;
        dataMap = [];
    }
    List<Widget> l = List<Widget>.generate(
      carouselLength,
      (index) => CarouselCard(
        name: dataMap[index]['name'],
        index: index,
      ),
    );
    return l;
  }

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

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        zoom,
      ),
    );
  }

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
    Position pos = await Geolocator.getCurrentPosition();
    userlat = pos.latitude;
    userlong = pos.longitude;
    return LatLng(pos.latitude, pos.longitude);
  }

  final pointIcon = 'assets/images/pointicon.png';
  final busIcon = 'assets/images/busicon.png';
  final restaurauntIcon = 'assets/images/restaurantIcon.png';
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
