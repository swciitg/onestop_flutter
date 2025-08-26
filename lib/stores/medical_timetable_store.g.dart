// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_timetable_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MedicalTimetableStore on _MedicalTimetableStore, Store {
  Computed<bool>? _$institutionDoctorsPresentComputed;

  @override
  bool get institutionDoctorsPresent =>
      (_$institutionDoctorsPresentComputed ??= Computed<bool>(
            () => super.institutionDoctorsPresent,
            name: '_MedicalTimetableStore.institutionDoctorsPresent',
          ))
          .value;
  Computed<bool>? _$visitingDoctorsPresentComputed;

  @override
  bool get visitingDoctorsPresent =>
      (_$visitingDoctorsPresentComputed ??= Computed<bool>(
            () => super.visitingDoctorsPresent,
            name: '_MedicalTimetableStore.visitingDoctorsPresent',
          ))
          .value;
  Computed<List<DoctorModel>>? _$todayMedicalTimeTableComputed;

  @override
  List<DoctorModel> get todayMedicalTimeTable =>
      (_$todayMedicalTimeTableComputed ??= Computed<List<DoctorModel>>(
            () => super.todayMedicalTimeTable,
            name: '_MedicalTimetableStore.todayMedicalTimeTable',
          ))
          .value;

  late final _$isProcessedAtom = Atom(
    name: '_MedicalTimetableStore.isProcessed',
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

  late final _$doctorsAtom = Atom(
    name: '_MedicalTimetableStore.doctors',
    context: context,
  );

  @override
  AllDoctors? get doctors {
    _$doctorsAtom.reportRead();
    return super.doctors;
  }

  @override
  set doctors(AllDoctors? value) {
    _$doctorsAtom.reportWrite(value, super.doctors, () {
      super.doctors = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: '_MedicalTimetableStore.selectedDate',
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
    name: '_MedicalTimetableStore.selectedDay',
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

  late final _$_MedicalTimetableStoreActionController = ActionController(
    name: '_MedicalTimetableStore',
    context: context,
  );

  @override
  void setDate(int i) {
    final _$actionInfo = _$_MedicalTimetableStoreActionController.startAction(
      name: '_MedicalTimetableStore.setDate',
    );
    try {
      return super.setDate(i);
    } finally {
      _$_MedicalTimetableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDay(int i) {
    final _$actionInfo = _$_MedicalTimetableStoreActionController.startAction(
      name: '_MedicalTimetableStore.setDay',
    );
    try {
      return super.setDay(i);
    } finally {
      _$_MedicalTimetableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isProcessed: ${isProcessed},
doctors: ${doctors},
selectedDate: ${selectedDate},
selectedDay: ${selectedDay},
institutionDoctorsPresent: ${institutionDoctorsPresent},
visitingDoctorsPresent: ${visitingDoctorsPresent},
todayMedicalTimeTable: ${todayMedicalTimeTable}
    ''';
  }
}
