// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimetableStore on _TimetableStore, Store {
  Computed<List<Widget>>? _$todayTimeTableComputed;

  @override
  List<Widget> get todayTimeTable =>
      (_$todayTimeTableComputed ??= Computed<List<Widget>>(
            () => super.todayTimeTable,
            name: '_TimetableStore.todayTimeTable',
          ))
          .value;

  late final _$isProcessedAtom = Atom(
    name: '_TimetableStore.isProcessed',
    context: context,
  );

  @override
  bool get isProcessed {
    _$isProcessedAtom.reportRead();
    return super.isProcessed;
  }

  @override
  set isProcessed(bool value) {
    _$isProcessedAtom.reportWrite(value, super.isProcessed, () {
      super.isProcessed = value;
    });
  }

  late final _$coursesAtom = Atom(
    name: '_TimetableStore.courses',
    context: context,
  );

  @override
  RegisteredCourses? get courses {
    _$coursesAtom.reportRead();
    return super.courses;
  }

  @override
  set courses(RegisteredCourses? value) {
    _$coursesAtom.reportWrite(value, super.courses, () {
      super.courses = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: '_TimetableStore.selectedDate',
    context: context,
  );

  @override
  int get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(int value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$selectedDayAtom = Atom(
    name: '_TimetableStore.selectedDay',
    context: context,
  );

  @override
  int get selectedDay {
    _$selectedDayAtom.reportRead();
    return super.selectedDay;
  }

  @override
  set selectedDay(int value) {
    _$selectedDayAtom.reportWrite(value, super.selectedDay, () {
      super.selectedDay = value;
    });
  }

  late final _$showDropDownAtom = Atom(
    name: '_TimetableStore.showDropDown',
    context: context,
  );

  @override
  bool get showDropDown {
    _$showDropDownAtom.reportRead();
    return super.showDropDown;
  }

  @override
  set showDropDown(bool value) {
    _$showDropDownAtom.reportWrite(value, super.showDropDown, () {
      super.showDropDown = value;
    });
  }

  late final _$isTimetableAtom = Atom(
    name: '_TimetableStore.isTimetable',
    context: context,
  );

  @override
  bool get isTimetable {
    _$isTimetableAtom.reportRead();
    return super.isTimetable;
  }

  @override
  set isTimetable(bool value) {
    _$isTimetableAtom.reportWrite(value, super.isTimetable, () {
      super.isTimetable = value;
    });
  }

  late final _$_TimetableStoreActionController = ActionController(
    name: '_TimetableStore',
    context: context,
  );

  @override
  void setDate(int i) {
    final _$actionInfo = _$_TimetableStoreActionController.startAction(
      name: '_TimetableStore.setDate',
    );
    try {
      return super.setDate(i);
    } finally {
      _$_TimetableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDay(int i) {
    final _$actionInfo = _$_TimetableStoreActionController.startAction(
      name: '_TimetableStore.setDay',
    );
    try {
      return super.setDay(i);
    } finally {
      _$_TimetableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleDropDown() {
    final _$actionInfo = _$_TimetableStoreActionController.startAction(
      name: '_TimetableStore.toggleDropDown',
    );
    try {
      return super.toggleDropDown();
    } finally {
      _$_TimetableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDropDown(bool b) {
    final _$actionInfo = _$_TimetableStoreActionController.startAction(
      name: '_TimetableStore.setDropDown',
    );
    try {
      return super.setDropDown(b);
    } finally {
      _$_TimetableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTT() {
    final _$actionInfo = _$_TimetableStoreActionController.startAction(
      name: '_TimetableStore.setTT',
    );
    try {
      return super.setTT();
    } finally {
      _$_TimetableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isProcessed: ${isProcessed},
courses: ${courses},
selectedDate: ${selectedDate},
selectedDay: ${selectedDay},
showDropDown: ${showDropDown},
isTimetable: ${isTimetable},
todayTimeTable: ${todayTimeTable}
    ''';
  }
}
