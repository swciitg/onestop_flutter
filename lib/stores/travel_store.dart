// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/services/data_service.dart';

part 'travel_store.g.dart';

class TravelStore = _TravelStore with _$TravelStore;

abstract class _TravelStore with Store {
  @observable
  int selectBusesorStops = 0;

  @observable
  String busDayType = "Weekdays";

  @observable
  String ferryDirection = "Campus to City";

  @observable
  String ferryDayType = "Mon - Sat";

  @observable
  String selectedFerryGhat = "Mazgaon";

  @observable
  ObservableList<TravelTiming> ferryTimings =
      ObservableList<TravelTiming>.of([]);

  @observable
  ObservableList<TravelTiming> busTimings = ObservableList<TravelTiming>.of([]);

  @action
  Future<List<TravelTiming>> getBusTimings() async {
    if (busTimings.isEmpty) {
      busTimings =
          ObservableList<TravelTiming>.of((await DataService.getBusTiming()));
    }
    return busTimings;
  }

  @action
  Future<List<TravelTiming>> getFerryTimings() async {
    if (ferryTimings.isEmpty) {
      ferryTimings =
          ObservableList<TravelTiming>.of((await DataService.getFerryTiming()));
    }
    return ferryTimings;
  }

  @action
  void setFerryDayType(String s) {
    ferryDayType = s;
  }

  @action
  void setFerryToCity() {
    ferryDirection = "Campus to City";
  }

  @action
  void setFerryToCampus() {
    ferryDirection = "City to Campus";
  }

  @action
  void setFerryDirection(String s) {
    ferryDirection = s;
  }

  @computed
  int get busDayTypeIndex => (busDayType == 'Weekdays') ? 1 : 0;

  @action
  void selectBusButton() {
    selectBusesorStops = 1;
  }

  @action
  void selectStopButton() {
    selectBusesorStops = 0;
  }

  @computed
  bool get isBusSelected => selectBusesorStops == 1;

  @action
  void setBusDayString(String s) {
    busDayType = s;
  }

  @action
  void setFerryGhat(String s) {
    selectedFerryGhat = s;
  }
}
