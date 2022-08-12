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
  Computed<Widget>? _$busPageComputed;

  @override
  Widget get busPage => (_$busPageComputed ??=
          Computed<Widget>(() => super.busPage, name: '_TravelStore.busPage'))
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

  late final _$_TravelStoreActionController =
      ActionController(name: '_TravelStore', context: context);

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
  String toString() {
    return '''
selectBusesorStops: ${selectBusesorStops},
busDayType: ${busDayType},
busDayTypeIndex: ${busDayTypeIndex},
busPage: ${busPage},
isBusSelected: ${isBusSelected}
    ''';
  }
}
