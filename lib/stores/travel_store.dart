import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/widgets/travel/bus_details.dart';
import 'package:onestop_dev/widgets/travel/stops_list.dart';
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

  @action
  void setFerryDayType(String s) {
    ferryDayType = s;
  }

  @action
  void setFerryToCity() {
    ferryDirection = "Campus to City";
  }

  @computed
  int get ferryDataIndex {
    if (ferryDirection == 'Campus to City') {
      if (ferryDayType == 'Sunday') {
        return 0;
      } else {
        return 1;
      }
    } else {
      if (ferryDayType == 'Sunday') {
        return 2;
      } else {
        return 3;
      }
    }
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

  @computed
  Widget get busPage {
    if (!isBusSelected) {
      return BusStopList();
    }
    return BusDetails(index: busDayTypeIndex);
  }

  @action
  void selectBusButton() {
    this.selectBusesorStops = 1;
  }

  @action
  void selectStopButton() {
    this.selectBusesorStops = 0;
  }

  @computed
  bool get isBusSelected => this.selectBusesorStops == 1;

  @action
  void setBusDayString(String s) {
    this.busDayType = s;
  }



}