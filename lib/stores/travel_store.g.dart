// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TravelStore on _TravelStore, Store {
  Computed<int>? _$busDayTypeIndexComputed;

  @override
  int get busDayTypeIndex =>
      (_$busDayTypeIndexComputed ??= Computed<int>(() => super.busDayTypeIndex,
              name: '_TravelStore.busDayTypeIndex'))
          .value;
  Computed<bool>? _$isBusSelectedComputed;

  @override
  bool get isBusSelected =>
      (_$isBusSelectedComputed ??= Computed<bool>(() => super.isBusSelected,
              name: '_TravelStore.isBusSelected'))
          .value;

  late final _$selectBusesorStopsAtom =
      Atom(name: '_TravelStore.selectBusesorStops', context: context);

  @override
  int get selectBusesorStops {
    _$selectBusesorStopsAtom.reportRead();
    return super.selectBusesorStops;
  }

  @override
  set selectBusesorStops(int value) {
    _$selectBusesorStopsAtom.reportWrite(value, super.selectBusesorStops, () {
      super.selectBusesorStops = value;
    });
  }

  late final _$busDayTypeAtom =
      Atom(name: '_TravelStore.busDayType', context: context);

  @override
  String get busDayType {
    _$busDayTypeAtom.reportRead();
    return super.busDayType;
  }

  @override
  set busDayType(String value) {
    _$busDayTypeAtom.reportWrite(value, super.busDayType, () {
      super.busDayType = value;
    });
  }

  late final _$ferryDirectionAtom =
      Atom(name: '_TravelStore.ferryDirection', context: context);

  @override
  String get ferryDirection {
    _$ferryDirectionAtom.reportRead();
    return super.ferryDirection;
  }

  @override
  set ferryDirection(String value) {
    _$ferryDirectionAtom.reportWrite(value, super.ferryDirection, () {
      super.ferryDirection = value;
    });
  }

  late final _$ferryDayTypeAtom =
      Atom(name: '_TravelStore.ferryDayType', context: context);

  @override
  String get ferryDayType {
    _$ferryDayTypeAtom.reportRead();
    return super.ferryDayType;
  }

  @override
  set ferryDayType(String value) {
    _$ferryDayTypeAtom.reportWrite(value, super.ferryDayType, () {
      super.ferryDayType = value;
    });
  }

  late final _$selectedFerryGhatAtom =
      Atom(name: '_TravelStore.selectedFerryGhat', context: context);

  @override
  String get selectedFerryGhat {
    _$selectedFerryGhatAtom.reportRead();
    return super.selectedFerryGhat;
  }

  @override
  set selectedFerryGhat(String value) {
    _$selectedFerryGhatAtom.reportWrite(value, super.selectedFerryGhat, () {
      super.selectedFerryGhat = value;
    });
  }

  late final _$ferryTimingsAtom =
      Atom(name: '_TravelStore.ferryTimings', context: context);

  @override
  ObservableList<TravelTiming> get ferryTimings {
    _$ferryTimingsAtom.reportRead();
    return super.ferryTimings;
  }

  @override
  set ferryTimings(ObservableList<TravelTiming> value) {
    _$ferryTimingsAtom.reportWrite(value, super.ferryTimings, () {
      super.ferryTimings = value;
    });
  }

  late final _$busTimingsAtom =
      Atom(name: '_TravelStore.busTimings', context: context);

  @override
  ObservableList<TravelTiming> get busTimings {
    _$busTimingsAtom.reportRead();
    return super.busTimings;
  }

  @override
  set busTimings(ObservableList<TravelTiming> value) {
    _$busTimingsAtom.reportWrite(value, super.busTimings, () {
      super.busTimings = value;
    });
  }

  late final _$getBusTimingsAsyncAction =
      AsyncAction('_TravelStore.getBusTimings', context: context);

  @override
  Future<List<TravelTiming>> getBusTimings() {
    return _$getBusTimingsAsyncAction.run(() => super.getBusTimings());
  }

  late final _$getFerryTimingsAsyncAction =
      AsyncAction('_TravelStore.getFerryTimings', context: context);

  @override
  Future<List<TravelTiming>> getFerryTimings() {
    return _$getFerryTimingsAsyncAction.run(() => super.getFerryTimings());
  }

  late final _$_TravelStoreActionController =
      ActionController(name: '_TravelStore', context: context);

  @override
  void setFerryDayType(String s) {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.setFerryDayType');
    try {
      return super.setFerryDayType(s);
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFerryToCity() {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.setFerryToCity');
    try {
      return super.setFerryToCity();
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFerryToCampus() {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.setFerryToCampus');
    try {
      return super.setFerryToCampus();
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFerryDirection(String s) {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.setFerryDirection');
    try {
      return super.setFerryDirection(s);
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectBusButton() {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.selectBusButton');
    try {
      return super.selectBusButton();
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectStopButton() {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.selectStopButton');
    try {
      return super.selectStopButton();
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBusDayString(String s) {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.setBusDayString');
    try {
      return super.setBusDayString(s);
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFerryGhat(String s) {
    final _$actionInfo = _$_TravelStoreActionController.startAction(
        name: '_TravelStore.setFerryGhat');
    try {
      return super.setFerryGhat(s);
    } finally {
      _$_TravelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectBusesorStops: ${selectBusesorStops},
busDayType: ${busDayType},
ferryDirection: ${ferryDirection},
ferryDayType: ${ferryDayType},
selectedFerryGhat: ${selectedFerryGhat},
ferryTimings: ${ferryTimings},
busTimings: ${busTimings},
busDayTypeIndex: ${busDayTypeIndex},
isBusSelected: ${isBusSelected}
    ''';
  }
}
