// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/widgets/contact/starred_contact.dart';
import 'package:onestop_ui/index.dart';

part 'contact_store.g.dart';

class ContactStore = _ContactStore with _$ContactStore;

abstract class _ContactStore with Store {
  @observable
  ObservableList<ContactDetailsModel> starredContacts = ObservableList<ContactDetailsModel>.of([]);

  @observable
  bool starredLoaded = false;

  @action
  Future<void> loadStarredContacts() async {
    var starred = await LocalStorage.instance.getListRecord(DatabaseRecords.starredContacts);
    if (starred == null) {
      starredContacts = ObservableList<ContactDetailsModel>.of([]);
    } else {
      starredContacts = ObservableList<ContactDetailsModel>.of(
        starred.map((e) => ContactDetailsModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    }
    starredLoaded = true;
  }

  Future<List<ContactDetailsModel>> getAllStarredContacts() async {
    var starred = await LocalStorage.instance.getListRecord(DatabaseRecords.starredContacts);
    if (starred == null) {
      return [];
    }
    var starredContacts =
        starred.map((e) => ContactDetailsModel.fromJson(e as Map<String, dynamic>)).toList();
    return starredContacts;
  }

  @action
  void setStarredContacts(List<ContactDetailsModel> l) {
    starredContacts = ObservableList<ContactDetailsModel>.of(l);
  }

  @computed
  List<Widget> get starContactScroll {
    if (starredContacts.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(left: OSpacing.m),
          child: Text(
            "You have no starred contacts",
            style: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
          ),
        ),
      ];
    }
    return starredContacts.map((element) => StarContactNameTile(contact: element)).toList();
  }
}
