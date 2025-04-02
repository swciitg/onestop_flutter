import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/stores/event_store.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatefulWidget {
  final EventModel event;
  const SaveButton({super.key, required this.event});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  Future<bool> isSaved() async {
    var saved =
        await LocalStorage.instance.getListRecord(DatabaseRecords.savedEvents);
    if (saved == null) {
      return false;
    }
    var savedEvents = saved
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    if (savedEvents.where((e) => e.id == widget.event.id).toList().isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isSaved(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isAlreadySaved = snapshot.data as bool;
            if (isAlreadySaved) {
              return IconButton(
                  onPressed: () async {
                    var saved = await LocalStorage.instance
                        .getListRecord(DatabaseRecords.savedEvents);
                    if (saved == null) return;
                    var savedEvents = saved
                        .map((e) =>
                            EventModel.fromJson(e as Map<String, dynamic>))
                        .toList();
                    savedEvents.removeWhere((e) => e.id == widget.event.id);
                    if (!mounted) return;
                    context.read<EventsStore>().setSavedEvents(savedEvents);
                    if (savedEvents.isEmpty) {
                      await LocalStorage.instance
                          .deleteRecord(DatabaseRecords.savedEvents);
                    } else {
                      List<Map<String, dynamic>> savedList =
                          savedEvents.map((e) => e.toJson()).toList();
                      await LocalStorage.instance.storeListRecord(
                          savedList, DatabaseRecords.savedEvents);
                    }
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.bookmark_rounded,
                    color: kWhite,
                  ));
            } else {
              return IconButton(
                  onPressed: () async {
                    var saved = await LocalStorage.instance
                        .getListRecord(DatabaseRecords.savedEvents);
                    List<Map<String, dynamic>> savedList = [];
                    if (saved == null) {
                      savedList.add(widget.event.toJson());
                      await LocalStorage.instance.storeListRecord(
                          savedList, DatabaseRecords.savedEvents);
                    } else {
                      savedList =
                          saved.map((e) => e as Map<String, dynamic>).toList();
                      savedList.add(widget.event.toJson());
                      await LocalStorage.instance.storeListRecord(
                          savedList, DatabaseRecords.savedEvents);
                    }
                    if (!mounted) return;
                    context.read<EventsStore>().setSavedEvents(
                        savedList.map((e) => EventModel.fromJson(e)).toList());
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: kWhite,
                  ));
            }
          } else {
            return Container();
          }
        });
  }
}
