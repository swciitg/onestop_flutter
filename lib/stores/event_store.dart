import 'package:mobx/mobx.dart';
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

  int get pageSize => 5;
}
