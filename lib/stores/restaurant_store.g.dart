// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RestaurantStore on _RestaurantStore, Store {
  final _$_selectedRestaurantAtom =
      Atom(name: '_RestaurantStore._selectedRestaurant');

  @override
  RestaurantModel get _selectedRestaurant {
    _$_selectedRestaurantAtom.reportRead();
    return super._selectedRestaurant;
  }

  @override
  set _selectedRestaurant(RestaurantModel value) {
    _$_selectedRestaurantAtom.reportWrite(value, super._selectedRestaurant, () {
      super._selectedRestaurant = value;
    });
  }

  final _$_RestaurantStoreActionController =
      ActionController(name: '_RestaurantStore');

  @override
  void setSelectedRestaurant(RestaurantModel r) {
    final _$actionInfo = _$_RestaurantStoreActionController.startAction(
        name: '_RestaurantStore.setSelectedRestaurant');
    try {
      return super.setSelectedRestaurant(r);
    } finally {
      _$_RestaurantStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
