// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TravelStore on _TravelStore, Store {
  Computed<List<Widget>>? _$busPageComputed;

  @override
  List<Widget> get busPage =>
      (_$busPageComputed ??= Computed<List<Widget>>(() => super.busPage,
              name: '_TravelStore.busPage'))
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

  @override
  String toString() {
    return '''
selectBusesorStops: ${selectBusesorStops},
busPage: ${busPage}
    ''';
  }
}
