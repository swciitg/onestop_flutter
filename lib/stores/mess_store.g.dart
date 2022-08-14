// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mess_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MessStore on _MessStore, Store {
  late final _$selectedDayAtom =
      Atom(name: '_MessStore.selectedDay', context: context);

  @override
  String get selectedDay {
    _$selectedDayAtom.reportRead();
    return super.selectedDay;
  }

  @override
  set selectedDay(String value) {
    _$selectedDayAtom.reportWrite(value, super.selectedDay, () {
      super.selectedDay = value;
    });
  }

  late final _$selectedMealAtom =
      Atom(name: '_MessStore.selectedMeal', context: context);

  @override
  String get selectedMeal {
    _$selectedMealAtom.reportRead();
    return super.selectedMeal;
  }

  @override
  set selectedMeal(String value) {
    _$selectedMealAtom.reportWrite(value, super.selectedMeal, () {
      super.selectedMeal = value;
    });
  }

  late final _$selectedHostelAtom =
      Atom(name: '_MessStore.selectedHostel', context: context);

  @override
  String get selectedHostel {
    _$selectedHostelAtom.reportRead();
    return super.selectedHostel;
  }

  @override
  set selectedHostel(String value) {
    _$selectedHostelAtom.reportWrite(value, super.selectedHostel, () {
      super.selectedHostel = value;
    });
  }

  late final _$selectedMessModelAtom =
      Atom(name: '_MessStore.selectedMessModel', context: context);

  @override
  MessMenuModel? get selectedMessModel {
    _$selectedMessModelAtom.reportRead();
    return super.selectedMessModel;
  }

  @override
  set selectedMessModel(MessMenuModel? value) {
    _$selectedMessModelAtom.reportWrite(value, super.selectedMessModel, () {
      super.selectedMessModel = value;
    });
  }

  late final _$allMessDataAtom =
      Atom(name: '_MessStore.allMessData', context: context);

  @override
  ObservableFuture<List<MessMenuModel>> get allMessData {
    _$allMessDataAtom.reportRead();
    return super.allMessData;
  }

  @override
  set allMessData(ObservableFuture<List<MessMenuModel>> value) {
    _$allMessDataAtom.reportWrite(value, super.allMessData, () {
      super.allMessData = value;
    });
  }

  late final _$_MessStoreActionController =
      ActionController(name: '_MessStore', context: context);

  @override
  void setDay(String s) {
    final _$actionInfo =
        _$_MessStoreActionController.startAction(name: '_MessStore.setDay');
    try {
      return super.setDay(s);
    } finally {
      _$_MessStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMeal(String s) {
    final _$actionInfo =
        _$_MessStoreActionController.startAction(name: '_MessStore.setMeal');
    try {
      return super.setMeal(s);
    } finally {
      _$_MessStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHostel(String s) {
    final _$actionInfo =
        _$_MessStoreActionController.startAction(name: '_MessStore.setHostel');
    try {
      return super.setHostel(s);
    } finally {
      _$_MessStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedMessModel(MessMenuModel m) {
    final _$actionInfo = _$_MessStoreActionController.startAction(
        name: '_MessStore.setSelectedMessModel');
    try {
      return super.setSelectedMessModel(m);
    } finally {
      _$_MessStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedDay: ${selectedDay},
selectedMeal: ${selectedMeal},
selectedHostel: ${selectedHostel},
selectedMessModel: ${selectedMessModel},
allMessData: ${allMessData}
    ''';
  }
}
