// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/event_scheduler/admin_model.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events_feed/event_tile.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_kit/onestop_kit.dart';

part 'event_store.g.dart';

class EventsStore = _EventsStore with _$EventsStore;

abstract class _EventsStore with Store {
  @observable
  int selectedEventTab = 0;

  @observable
  bool isAdminView = false;

  @action
  void setSelectedEventTab(int newIndex) {
    selectedEventTab = newIndex;
  }

  @action
  void toggleAdminView() {
    isAdminView = !isAdminView;
  }

  @observable
  Admin? admin = null;

  @action
  void setAdmin(Admin updated) {
    admin = updated;
  }

  @computed
  String get currentEventCategory {
    if (isAdminView) {
      switch (selectedEventTab) {
        case 0:
          return "Your Events";
        case 1:
          return "All Events";
        case 2:
          return "Academic";
        case 3:
          return "Sports";
        case 4:
          return "Technical";
        case 5:
          return "Cultural";
        case 6:
          return "Welfare";
        case 7:
          return "SWC";
        case 8:
          return "Miscellaneous";
        default:
          return "Your Events";
      }
    } else {
      switch (selectedEventTab) {
        case 0:
          return "Saved";
        case 1:
          return "All Events";
        case 2:
          return "Academic";
        case 3:
          return "Sports";
        case 4:
          return "Technical";
        case 5:
          return "Cultural";
        case 6:
          return "Welfare";
        case 7:
          return "SWC";
        case 8:
          return "Miscellaneous";
        default:
          return "Saved";
      }
    }
  }

  int get pageSize => 10;

  @observable
  ObservableList<EventModel> savedEvents = ObservableList<EventModel>.of([]);

  Future<List<EventModel>> getAllSavedEvents() async {
    var saved =
        await LocalStorage.instance.getListRecord(DatabaseRecords.savedEvents);
    if (saved == null) {
      return [];
    }
    var savedEvents = saved
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return savedEvents;
  }

  @action
  void setSavedEvents(List<EventModel> l) {
    savedEvents = ObservableList<EventModel>.of(l);
  }

  @computed
  List<EventModel> get activeSavedEvents {
    final currentTime = DateTime.now();
    return savedEvents
        .where((event) => event.endDateTime.isAfter(currentTime))
        .toList();
  }

  @computed
  List<Widget> get savedScroll {
    if (activeSavedEvents.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "You have no active saved events_feed",
            style: MyFonts.w400.setColor(kGrey8),
          ),
        )
      ];
    }
    return activeSavedEvents
        .map((element) => EventTile(
              onTap: () {
                // Add your onTap navigation logic here if needed
              },
              model: element,
            ))
        .toList();
  }
}
