// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapbox_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MapBoxStore on _MapBoxStore, Store {
  Computed<List<Map<String, dynamic>>>? _$allLocationDataComputed;

  @override
  List<Map<String, dynamic>> get allLocationData =>
      (_$allLocationDataComputed ??= Computed<List<Map<String, dynamic>>>(
              () => super.allLocationData,
              name: '_MapBoxStore.allLocationData'))
          .value;
  Computed<LatLng>? _$selectedCarouselLatLngComputed;

  @override
  LatLng get selectedCarouselLatLng => (_$selectedCarouselLatLngComputed ??=
          Computed<LatLng>(() => super.selectedCarouselLatLng,
              name: '_MapBoxStore.selectedCarouselLatLng'))
      .value;
  Computed<LatLng>? _$userLatLngComputed;

  @override
  LatLng get userLatLng =>
      (_$userLatLngComputed ??= Computed<LatLng>(() => super.userLatLng,
              name: '_MapBoxStore.userLatLng'))
          .value;
  Computed<List<Widget>>? _$carouselCardsComputed;

  @override
  List<Widget> get carouselCards => (_$carouselCardsComputed ??=
          Computed<List<Widget>>(() => super.carouselCards,
              name: '_MapBoxStore.carouselCards'))
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

  late final _$busStopPolylinesAtom =
      Atom(name: '_MapBoxStore.busStopPolylines', context: context);

  @override
  List<Polyline> get busStopPolylines {
    _$busStopPolylinesAtom.reportRead();
    return super.busStopPolylines;
  }

  @override
  set busStopPolylines(List<Polyline> value) {
    _$busStopPolylinesAtom.reportWrite(value, super.busStopPolylines, () {
      super.busStopPolylines = value;
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
  ObservableList<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(ObservableList<Marker> value) {
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

  late final _$_MapBoxStoreActionController =
      ActionController(name: '_MapBoxStore', context: context);

  @override
  void setMarkers(List<Marker> m) {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.setMarkers');
    try {
      return super.setMarkers(m);
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

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
  void generateAllMarkers() {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.generateAllMarkers');
    try {
      return super.generateAllMarkers();
    } finally {
      _$_MapBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeCenterZoom(double lat, double long) {
    final _$actionInfo = _$_MapBoxStoreActionController.startAction(
        name: '_MapBoxStore.changeCenterZoom');
    try {
      return super.changeCenterZoom(lat, long);
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
  String toString() {
    return '''
indexBusesorFerry: ${indexBusesorFerry},
userlat: ${userlat},
userlong: ${userlong},
selectedCarouselIndex: ${selectedCarouselIndex},
isTravelPage: ${isTravelPage},
myPos: ${myPos},
busStopPolylines: ${busStopPolylines},
loadOperation: ${loadOperation},
markers: ${markers},
allLocationData: ${allLocationData},
selectedCarouselLatLng: ${selectedCarouselLatLng},
userLatLng: ${userLatLng},
carouselCards: ${carouselCards}
    ''';
  }
}
