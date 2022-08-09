// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapbox_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MapBoxStore on _MapBoxStore, Store {
  Computed<List<Widget>>? _$buses_carouselComputed;

  @override
  List<Widget> get buses_carousel => (_$buses_carouselComputed ??=
          Computed<List<Widget>>(() => super.buses_carousel,
              name: '_MapBoxStore.buses_carousel'))
      .value;

  late final _$indexBusesorFerryAtom =
      Atom(name: '_MapBoxStore.indexBusesorFerry', context: context);

  @override
  int get indexBusesorFerry {
    _$indexBusesorFerryAtom.reportRead();
    return super.indexBusesorFerry;
  }

  @override
  set indexBusesorFerry(int value) {
    _$indexBusesorFerryAtom.reportWrite(value, super.indexBusesorFerry, () {
      super.indexBusesorFerry = value;
    });
  }

  late final _$userlatAtom =
      Atom(name: '_MapBoxStore.userlat', context: context);

  @override
  double get userlat {
    _$userlatAtom.reportRead();
    return super.userlat;
  }

  @override
  set userlat(double value) {
    _$userlatAtom.reportWrite(value, super.userlat, () {
      super.userlat = value;
    });
  }

  late final _$userlongAtom =
      Atom(name: '_MapBoxStore.userlong', context: context);

  @override
  double get userlong {
    _$userlongAtom.reportRead();
    return super.userlong;
  }

  @override
  set userlong(double value) {
    _$userlongAtom.reportWrite(value, super.userlong, () {
      super.userlong = value;
    });
  }

  late final _$selectedCarouselIndexAtom =
      Atom(name: '_MapBoxStore.selectedCarouselIndex', context: context);

  @override
  int get selectedCarouselIndex {
    _$selectedCarouselIndexAtom.reportRead();
    return super.selectedCarouselIndex;
  }

  @override
  set selectedCarouselIndex(int value) {
    _$selectedCarouselIndexAtom.reportWrite(value, super.selectedCarouselIndex,
        () {
      super.selectedCarouselIndex = value;
    });
  }

  late final _$isTravelPageAtom =
      Atom(name: '_MapBoxStore.isTravelPage', context: context);

  @override
  bool get isTravelPage {
    _$isTravelPageAtom.reportRead();
    return super.isTravelPage;
  }

  @override
  set isTravelPage(bool value) {
    _$isTravelPageAtom.reportWrite(value, super.isTravelPage, () {
      super.isTravelPage = value;
    });
  }

  late final _$myPosAtom = Atom(name: '_MapBoxStore.myPos', context: context);

  @override
  LatLng get myPos {
    _$myPosAtom.reportRead();
    return super.myPos;
  }

  @override
  set myPos(LatLng value) {
    _$myPosAtom.reportWrite(value, super.myPos, () {
      super.myPos = value;
    });
  }

  late final _$bus_carousel_dataAtom =
      Atom(name: '_MapBoxStore.bus_carousel_data', context: context);

  @override
  List<Map<dynamic, dynamic>> get bus_carousel_data {
    _$bus_carousel_dataAtom.reportRead();
    return super.bus_carousel_data;
  }

  @override
  set bus_carousel_data(List<Map<dynamic, dynamic>> value) {
    _$bus_carousel_dataAtom.reportWrite(value, super.bus_carousel_data, () {
      super.bus_carousel_data = value;
    });
  }

  late final _$bus_carousel_itemsAtom =
      Atom(name: '_MapBoxStore.bus_carousel_items', context: context);

  @override
  List<Widget> get bus_carousel_items {
    _$bus_carousel_itemsAtom.reportRead();
    return super.bus_carousel_items;
  }

  @override
  set bus_carousel_items(List<Widget> value) {
    _$bus_carousel_itemsAtom.reportWrite(value, super.bus_carousel_items, () {
      super.bus_carousel_items = value;
    });
  }

  late final _$bus_stop_polylinesAtom =
      Atom(name: '_MapBoxStore.bus_stop_polylines', context: context);

  @override
  List<Polyline> get bus_stop_polylines {
    _$bus_stop_polylinesAtom.reportRead();
    return super.bus_stop_polylines;
  }

  @override
  set bus_stop_polylines(List<Polyline> value) {
    _$bus_stop_polylinesAtom.reportWrite(value, super.bus_stop_polylines, () {
      super.bus_stop_polylines = value;
    });
  }

  late final _$loadOperationAtom =
      Atom(name: '_MapBoxStore.loadOperation', context: context);

  @override
  ObservableFuture<List<LatLng>?> get loadOperation {
    _$loadOperationAtom.reportRead();
    return super.loadOperation;
  }

  @override
  set loadOperation(ObservableFuture<List<LatLng>?> value) {
    _$loadOperationAtom.reportWrite(value, super.loadOperation, () {
      super.loadOperation = value;
    });
  }

  late final _$markersAtom =
      Atom(name: '_MapBoxStore.markers', context: context);

  @override
  List<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(List<Marker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  late final _$getPolylinesAsyncAction =
      AsyncAction('_MapBoxStore.getPolylines', context: context);

  @override
  Future<void> getPolylines(int i) {
    return _$getPolylinesAsyncAction.run(() => super.getPolylines(i));
  }

  late final _$getLocationAsyncAction =
      AsyncAction('_MapBoxStore.getLocation', context: context);

  @override
  Future<dynamic> getLocation() {
    return _$getLocationAsyncAction.run(() => super.getLocation());
  }

  late final _$_MapBoxStoreActionController =
      ActionController(name: '_MapBoxStore', context: context);

  @override
  void setIndexMapBox(int i) {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.setIndexMapBox');
    try {
      return super.setIndexMapBox(i);
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void change_centre_zoom(double lat, double long) {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.change_centre_zoom');
    try {
      return super.change_centre_zoom(lat, long);
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserLatLng(double lat, double long) {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.setUserLatLng');
    try {
      return super.setUserLatLng(lat, long);
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectedCarousel(int i) {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.selectedCarousel');
    try {
      return super.selectedCarousel(i);
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkTravelPage(bool i) {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.checkTravelPage');
    try {
      return super.checkTravelPage(i);
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initialiseCarouselforBuses() {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.initialiseCarouselforBuses');
    try {
      return super.initialiseCarouselforBuses();
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void generate_bus_markers() {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.generate_bus_markers');
    try {
      return super.generate_bus_markers();
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void generate_restaraunt_markers() {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.generate_restaraunt_markers');
    try {
      return super.generate_restaraunt_markers();
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
indexBusesorFerry: ${indexBusesorFerry},
userlat: ${userlat},
userlong: ${userlong},
selectedCarouselIndex: ${selectedCarouselIndex},
isTravelPage: ${isTravelPage},
myPos: ${myPos},
bus_carousel_data: ${bus_carousel_data},
bus_carousel_items: ${bus_carousel_items},
bus_stop_polylines: ${bus_stop_polylines},
loadOperation: ${loadOperation},
markers: ${markers},
buses_carousel: ${buses_carousel}
    ''';
  }
}
