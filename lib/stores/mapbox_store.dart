import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/functions/travel/check_weekday.dart';
import 'package:onestop_dev/pages/travel/data.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/mapbox/carousel_card.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
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
  LatLng myPos = LatLng(-37.327154, -59.119667);

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
    generateAllMarkers();
  }

  @action
  void generateAllMarkers() {
    List<Marker> l = List.generate(
      this.allLocationData.length,
          (index) => Marker(
          markerId: MarkerId('bus$index'),
          position: LatLng(this.allLocationData[index]['lat'],
              this.allLocationData[index]['long'])),
    );
    this.markers = ObservableList<Marker>.of(l);
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
          position: LatLng(allLocationData[i]['lat'],
              allLocationData[i]['long'])));
      this.markers = ObservableList<Marker>.of(l);
    });
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

  @computed
  List<Map<String,dynamic>> get allLocationData {
    List<Map<String, dynamic>> dataMap = [];
    switch (this.indexBusesorFerry) {
      case 0:
        dataMap = BusStops;
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
    var dataMap = this.allLocationData;
    return LatLng(dataMap[selectedCarouselIndex]['lat'],
        dataMap[selectedCarouselIndex]['long']);
  }

  @computed
  List<Widget> get carouselCards {
    int carouselLength = 0;
    List<Map<String, dynamic>> dataMap;
    switch (this.indexBusesorFerry) {
      case 0:
        carouselLength = BusStops.length;
        dataMap = BusStops;
        break;
      case 1:
        carouselLength = ferryGhats.length;
        dataMap = ferryGhats;
        break;
      default:
        carouselLength = 0;
        dataMap = [];
    }
    print("Data map is $dataMap");
    List<Widget> l = List<Widget>.generate(
      carouselLength,
      (index) => CarouselCard(
          name: dataMap[index]['name'],
          index: dataMap[index]['ind'],
          ),
    );
    return l;
  }


  Future<List<String>> getAppropriateTimings() async{
    // Bus = index 0
    // Ferry = index 1
    // if (this.indexBusesorFerry == 0)
       var busTimes = await DataProvider.getBusTimings();
       if(checkWeekday())
         {
           return busTimes[1];
         }
       else
         {
           return busTimes[0];
         }
    // else if(this.indexBusesorFerry == 1)
    //   {
    //     var ferryTimes = await DataProvider.getFerryTimings();
    //     var ghatName = allLocationData[selectedCarouselIndex]['name'];
    //     var requiredModel = ferryTimes.firstWhere((element) => element.name == ghatName);
    //     if(checkWeekday())
    //       {
    //         return requiredModel.MonToFri_NorthGuwahatiToGuwahati;
    //       }
    //     else
    //       {
    //         return requiredModel.Sunday_NorthGuwahatiToGuwahati;
    //       }
    //   }

    return [];

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
    this.userlat = pos.latitude;
    this.userlong = pos.longitude;
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