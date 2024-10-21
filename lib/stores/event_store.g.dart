// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventsStore on _EventsStore, Store {
  Computed<String>? _$currentEventCategoryComputed;

  @override
  String get currentEventCategory => (_$currentEventCategoryComputed ??=
          Computed<String>(() => super.currentEventCategory,
              name: '_EventsStore.currentEventCategory'))
      .value;
  Computed<List<Widget>>? _$savedScrollComputed;

  @override
  List<Widget> get savedScroll =>
      (_$savedScrollComputed ??= Computed<List<Widget>>(() => super.savedScroll,
              name: '_EventsStore.savedScroll'))
          .value;

  late final _$selectedEventTabAtom =
      Atom(name: '_EventsStore.selectedEventTab', context: context);

  @override
  int get selectedEventTab {
    _$selectedEventTabAtom.reportRead();
    return super.selectedEventTab;
  }

  @override
  set selectedEventTab(int value) {
    _$selectedEventTabAtom.reportWrite(value, super.selectedEventTab, () {
      super.selectedEventTab = value;
    });
  }

  late final _$isAdminViewAtom =
      Atom(name: '_EventsStore.isAdminView', context: context);

  @override
  bool get isAdminView {
    _$isAdminViewAtom.reportRead();
    return super.isAdminView;
  }

  @override
  set isAdminView(bool value) {
    _$isAdminViewAtom.reportWrite(value, super.isAdminView, () {
      super.isAdminView = value;
    });
  }

  late final _$adminAtom = Atom(name: '_EventsStore.admin', context: context);

  @override
  Admin? get admin {
    _$adminAtom.reportRead();
    return super.admin;
  }

  @override
  set admin(Admin? value) {
    _$adminAtom.reportWrite(value, super.admin, () {
      super.admin = value;
    });
  }

  late final _$savedEventsAtom =
      Atom(name: '_EventsStore.savedEvents', context: context);

  @override
  ObservableList<EventModel> get savedEvents {
    _$savedEventsAtom.reportRead();
    return super.savedEvents;
  }

  @override
  set savedEvents(ObservableList<EventModel> value) {
    _$savedEventsAtom.reportWrite(value, super.savedEvents, () {
      super.savedEvents = value;
    });
  }

  late final _$_EventsStoreActionController =
      ActionController(name: '_EventsStore', context: context);

  @override
  void setSelectedEventTab(int newIndex) {
    final _$actionInfo = _$_EventsStoreActionController.startAction(
        name: '_EventsStore.setSelectedEventTab');
    try {
      return super.setSelectedEventTab(newIndex);
    } finally {
      _$_EventsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleAdminView() {
    final _$actionInfo = _$_EventsStoreActionController.startAction(
        name: '_EventsStore.toggleAdminView');
    try {
      return super.toggleAdminView();
    } finally {
      _$_EventsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAdmin(Admin updated) {
    final _$actionInfo = _$_EventsStoreActionController.startAction(
        name: '_EventsStore.setAdmin');
    try {
      return super.setAdmin(updated);
    } finally {
      _$_EventsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSavedEvents(List<EventModel> l) {
    final _$actionInfo = _$_EventsStoreActionController.startAction(
        name: '_EventsStore.setSavedEvents');
    try {
      return super.setSavedEvents(l);
    } finally {
      _$_EventsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedEventTab: ${selectedEventTab},
isAdminView: ${isAdminView},
admin: ${admin},
savedEvents: ${savedEvents},
currentEventCategory: ${currentEventCategory},
savedScroll: ${savedScroll}
    ''';
  }
}
