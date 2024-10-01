// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mess_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MessStore on _MessStore, Store {
  Computed<bool>? _$messLoadedComputed;

  @override
  bool get messLoaded => (_$messLoadedComputed ??=
          Computed<bool>(() => super.messLoaded, name: '_MessStore.messLoaded'))
      .value;
  Computed<Mess>? _$defaultUserMessComputed;

  @override
  Mess get defaultUserMess =>
      (_$defaultUserMessComputed ??= Computed<Mess>(() => super.defaultUserMess,
              name: '_MessStore.defaultUserMess'))
          .value;

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

  late final _$selectedMessAtom =
      Atom(name: '_MessStore.selectedMess', context: context);

  @override
  ObservableFuture<Mess> get selectedMess {
    _$selectedMessAtom.reportRead();
    return super.selectedMess;
  }

  @override
  set selectedMess(ObservableFuture<Mess> value) {
    _$selectedMessAtom.reportWrite(value, super.selectedMess, () {
      super.selectedMess = value;
    });
  }

  late final _$mealDataAtom =
      Atom(name: '_MessStore.mealData', context: context);

  @override
  MealType get mealData {
    _$mealDataAtom.reportRead();
    return super.mealData;
  }

  @override
  set mealData(MealType value) {
    _$mealDataAtom.reportWrite(value, super.mealData, () {
      super.mealData = value;
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
  void setMess(Mess m) {
    final _$actionInfo =
        _$_MessStoreActionController.startAction(name: '_MessStore.setMess');
    try {
      return super.setMess(m);
    } finally {
      _$_MessStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMealData(MealType m) {
    final _$actionInfo = _$_MessStoreActionController.startAction(
        name: '_MessStore.setMealData');
    try {
      return super.setMealData(m);
    } finally {
      _$_MessStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedDay: ${selectedDay},
selectedMeal: ${selectedMeal},
selectedMess: ${selectedMess},
mealData: ${mealData},
messLoaded: ${messLoaded},
defaultUserMess: ${defaultUserMess}
    ''';
  }
}
