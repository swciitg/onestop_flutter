// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CommonStore on _CommonStore, Store {
  late final _$lnfIndexAtom =
      Atom(name: '_CommonStore.lnfIndex', context: context);

  @override
  String get lnfIndex {
    _$lnfIndexAtom.reportRead();
    return super.lnfIndex;
  }

  @override
  set lnfIndex(String value) {
    _$lnfIndexAtom.reportWrite(value, super.lnfIndex, () {
      super.lnfIndex = value;
    });
  }

  late final _$bnsIndexAtom =
      Atom(name: '_CommonStore.bnsIndex', context: context);

  @override
  String get bnsIndex {
    _$bnsIndexAtom.reportRead();
    return super.bnsIndex;
  }

  @override
  set bnsIndex(String value) {
    _$bnsIndexAtom.reportWrite(value, super.bnsIndex, () {
      super.bnsIndex = value;
    });
  }

  late final _$isPersonalNotifAtom =
      Atom(name: '_CommonStore.isPersonalNotif', context: context);

  @override
  bool get isPersonalNotif {
    _$isPersonalNotifAtom.reportRead();
    return super.isPersonalNotif;
  }

  @override
  set isPersonalNotif(bool value) {
    _$isPersonalNotifAtom.reportWrite(value, super.isPersonalNotif, () {
      super.isPersonalNotif = value;
    });
  }

  late final _$_CommonStoreActionController =
      ActionController(name: '_CommonStore', context: context);

  @override
  void setLnfIndex(String newIndex) {
    final _$actionInfo = _$_CommonStoreActionController.startAction(
        name: '_CommonStore.setLnfIndex');
    try {
      return super.setLnfIndex(newIndex);
    } finally {
      _$_CommonStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBnsIndex(String newIndex) {
    final _$actionInfo = _$_CommonStoreActionController.startAction(
        name: '_CommonStore.setBnsIndex');
    try {
      return super.setBnsIndex(newIndex);
    } finally {
      _$_CommonStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotif() {
    final _$actionInfo = _$_CommonStoreActionController.startAction(
        name: '_CommonStore.setNotif');
    try {
      return super.setNotif();
    } finally {
      _$_CommonStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
lnfIndex: ${lnfIndex},
bnsIndex: ${bnsIndex},
isPersonalNotif: ${isPersonalNotif}
    ''';
  }
}
