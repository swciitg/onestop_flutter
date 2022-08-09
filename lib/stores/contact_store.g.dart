// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContactStore on _ContactStore, Store {
  Computed<List<Widget>>? _$starContactScrollComputed;

  @override
  List<Widget> get starContactScroll => (_$starContactScrollComputed ??=
          Computed<List<Widget>>(() => super.starContactScroll,
              name: '_ContactStore.starContactScroll'))
      .value;

  late final _$starredContactsAtom =
      Atom(name: '_ContactStore.starredContacts', context: context);

  @override
  ObservableList<ContactDetailsModel> get starredContacts {
    _$starredContactsAtom.reportRead();
    return super.starredContacts;
  }

  @override
  set starredContacts(ObservableList<ContactDetailsModel> value) {
    _$starredContactsAtom.reportWrite(value, super.starredContacts, () {
      super.starredContacts = value;
    });
  }

  late final _$_ContactStoreActionController =
      ActionController(name: '_ContactStore', context: context);

  @override
  void setStarredContacts(List<ContactDetailsModel> l) {
    final _$actionInfo = _$_ContactStoreActionController.startAction(
        name: '_ContactStore.setStarredContacts');
    try {
      return super.setStarredContacts(l);
    } finally {
      _$_ContactStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
starredContacts: ${starredContacts},
starContactScroll: ${starContactScroll}
    ''';
  }
}
