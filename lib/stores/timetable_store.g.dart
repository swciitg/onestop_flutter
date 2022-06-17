// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimetableStore on _TimetableStore, Store {
  Computed<bool>? _$coursesLoadedComputed;

  @override
  bool get coursesLoaded =>
      (_$coursesLoadedComputed ??= Computed<bool>(() => super.coursesLoaded,
              name: '_TimetableStore.coursesLoaded'))
          .value;
  Computed<bool>? _$coursesLoadingComputed;

  @override
  bool get coursesLoading =>
      (_$coursesLoadingComputed ??= Computed<bool>(() => super.coursesLoading,
              name: '_TimetableStore.coursesLoading'))
          .value;
  Computed<bool>? _$coursesErrorComputed;

  @override
  bool get coursesError =>
      (_$coursesErrorComputed ??= Computed<bool>(() => super.coursesError,
              name: '_TimetableStore.coursesError'))
          .value;

  late final _$loadOperationAtom =
      Atom(name: '_TimetableStore.loadOperation', context: context);

  @override
  ObservableFuture<RegisteredCourses?> get loadOperation {
    _$loadOperationAtom.reportRead();
    return super.loadOperation;
  }

  @override
  set loadOperation(ObservableFuture<RegisteredCourses?> value) {
    _$loadOperationAtom.reportWrite(value, super.loadOperation, () {
      super.loadOperation = value;
    });
  }

  late final _$setTimetableAsyncAction =
      AsyncAction('_TimetableStore.setTimetable', context: context);

  @override
  Future<void> setTimetable(String rollNumber) {
    return _$setTimetableAsyncAction.run(() => super.setTimetable(rollNumber));
  }

  @override
  String toString() {
    return '''
loadOperation: ${loadOperation},
coursesLoaded: ${coursesLoaded},
coursesLoading: ${coursesLoading},
coursesError: ${coursesError}
    ''';
  }
}
