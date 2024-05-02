import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:provider/provider.dart';

class StarButton extends StatefulWidget {
  final ContactDetailsModel contact;
  const StarButton({Key? key, required this.contact}) : super(key: key);

  @override
  State<StarButton> createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  Future<bool> isStarred() async {
    var starred = await LocalStorage.instance
        .getListRecord(DatabaseRecords.starredContacts);
    if (starred == null) {
      return false;
    }
    var starredContacts = starred
        .map((e) => ContactDetailsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    if (starredContacts
        .where((element) => element.email == widget.contact.email)
        .toList()
        .isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isStarred(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isAlreadyStarred = snapshot.data as bool;
          if (isAlreadyStarred) {
            return IconButton(
              onPressed: () async {
                var starred = await LocalStorage.instance
                    .getListRecord(DatabaseRecords.starredContacts);
                if (starred == null) {
                  return;
                }
                var starredContacts = starred
                    .map((e) =>
                        ContactDetailsModel.fromJson(e as Map<String, dynamic>))
                    .toList();
                starredContacts.removeWhere(
                    (element) => element.email == widget.contact.email);
                if (!mounted) return;
                context
                    .read<ContactStore>()
                    .setStarredContacts(starredContacts);
                if (starredContacts.isEmpty) {
                  await LocalStorage.instance
                      .deleteRecord(DatabaseRecords.starredContacts);
                } else {
                  List<Map<String, dynamic>> starList =
                      starredContacts.map((e) => e.toJson()).toList();
                  await LocalStorage.instance.storeListRecord(
                      starList, DatabaseRecords.starredContacts);
                }
                setState(() {});
              },
              icon: const Icon(
                FluentIcons.star_12_filled,
                color: Colors.amber,
              ),
            );
          } else {
            return IconButton(
              onPressed: () async {
                var starred = await LocalStorage.instance
                    .getListRecord(DatabaseRecords.starredContacts);
                List<Map<String, dynamic>> starList = [];
                if (starred == null) {
                  starList.add(widget.contact.toJson());
                  await LocalStorage.instance.storeListRecord(
                      starList, DatabaseRecords.starredContacts);
                } else {
                  starList =
                      starred.map((e) => e as Map<String, dynamic>).toList();
                  starList.add(widget.contact.toJson());
                  await LocalStorage.instance.storeListRecord(
                      starList, DatabaseRecords.starredContacts);
                }
                if (!mounted) return;
                context.read<ContactStore>().setStarredContacts(starList
                    .map((e) => ContactDetailsModel.fromJson(e))
                    .toList());
                setState(() {});
              },
              icon: const Icon(
                FluentIcons.star_12_regular,
                color: kGrey,
              ),
            );
          }
        }
        return Container(
          height: 50,
        );
      },
    );
  }
}
