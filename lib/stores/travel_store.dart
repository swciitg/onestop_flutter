import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/widgets/travel/bus_details.dart';
import 'package:onestop_dev/widgets/travel/bus_stop_list.dart';
part 'travel_store.g.dart';

class TravelStore = _TravelStore with _$TravelStore;

abstract class _TravelStore with Store {
  @observable
  int selectBusesorStops = 0;

  @observable
  String busDayType = "Weekdays";

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