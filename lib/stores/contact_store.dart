import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/functions/contact/starred_contact.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/services/local_storage.dart';

part 'contact_store.g.dart';

class ContactStore = _ContactStore with _$ContactStore;

abstract class _ContactStore with Store {

  @observable
  ObservableList<ContactDetailsModel> starredContacts = ObservableList<ContactDetailsModel>.of([]);

  Future<List<ContactDetailsModel>> getAllStarredContacts() async {
    var starred = await LocalStorage.instance.getRecord("StarredContacts");
    if (starred == null) {
      return [];
    }
    var starredContacts = starred
        .map((e) => ContactDetailsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return starredContacts;
  }

  @action
  void setStarredContacts(List<ContactDetailsModel> l) {
    starredContacts = ObservableList<ContactDetailsModel>.of(l);
  }

  @computed
  List<Widget> get starContactScroll {
    if (starredContacts.length == 0) {
      return [Text("You have no starred contacts")];
    }
    return starredContacts.map((element) => StarContactNameTile(contact: element)).toList();
  }

}
