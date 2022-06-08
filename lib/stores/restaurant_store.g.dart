// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RestaurantStore on _RestaurantStore, Store {
  late final _$_searchStringAtom =
      Atom(name: '_RestaurantStore._searchString', context: context);

  @override
  String get _searchString {
    _$_searchStringAtom.reportRead();
    return super._searchString;
  }

  @override
  set _searchString(String value) {
    _$_searchStringAtom.reportWrite(value, super._searchString, () {
      super._searchString = value;
    });
  }

  late final _$_searchPageHeaderAtom =
      Atom(name: '_RestaurantStore._searchPageHeader', context: context);

  @override
  String get _searchPageHeader {
    _$_searchPageHeaderAtom.reportRead();
    return super._searchPageHeader;
  }

  @override
  set _searchPageHeader(String value) {
    _$_searchPageHeaderAtom.reportWrite(value, super._searchPageHeader, () {
      super._searchPageHeader = value;
    });
  }

  late final _$searchResultsAtom =
      Atom(name: '_RestaurantStore.searchResults', context: context);

  @override
  ObservableFuture<List<RestaurantModel>> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(ObservableFuture<List<RestaurantModel>> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$_RestaurantStoreActionController =
      ActionController(name: '_RestaurantStore', context: context);

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
  void setSearchString(String str) {
    final _$actionInfo = _$_RestaurantStoreActionController.startAction(
        name: '_RestaurantStore.setSearchString');
    try {
      return super.setSearchString(str);
    } finally {
      _$_RestaurantStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchHeader(String str) {
    final _$actionInfo = _$_RestaurantStoreActionController.startAction(
        name: '_RestaurantStore.setSearchHeader');
    try {
      return super.setSearchHeader(str);
    } finally {
      _$_RestaurantStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchResults: ${searchResults}
    ''';
  }
}
