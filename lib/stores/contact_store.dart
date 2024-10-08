// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/widgets/contact/starred_contact.dart';
import 'package:onestop_kit/onestop_kit.dart';

part 'contact_store.g.dart';

class ContactStore = _ContactStore with _$ContactStore;

abstract class _ContactStore with Store {
  @observable
  ObservableList<ContactDetailsModel> starredContacts =
      ObservableList<ContactDetailsModel>.of([]);

  Future<List<ContactDetailsModel>> getAllStarredContacts() async {
    var starred = await LocalStorage.instance
        .getListRecord(DatabaseRecords.starredContacts);
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
    if (starredContacts.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "You have no starred contacts",
            style: MyFonts.w400.setColor(kGrey8),
          ),
        )
      ];
    }
    return starredContacts
        .map((element) => StarContactNameTile(contact: element))
        .toList();
  }
}
