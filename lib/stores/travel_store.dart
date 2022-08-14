import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/models/travel/ferry_data_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
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

  @observable
  String selectedFerryGhat = "Rajaduwar";

  @observable
  ObservableFuture<List<FerryTimeData>> ferryTimings = ObservableFuture(DataProvider.getFerryTimings());

  @observable
  ObservableFuture<List<List<String>>> busTimings = ObservableFuture(DataProvider.getBusTimings());

  @action
  void setFerryDayType(String s) {
    ferryDayType = s;
  }

  @action
  void setFerryToCity() {
    ferryDirection = "Campus to City";
  }

  @computed
  String get ferryDataIndex {
    if (ferryDirection == 'Campus to City') {
      if (ferryDayType == 'Sunday') {
        return "Sunday_NorthGuwahatiToGuwahati";
      } else {
        return "MonToFri_NorthGuwahatiToGuwahati";
      }
    } else {
      if (ferryDayType == 'Sunday') {
        return "Sunday_GuwahatiToNorthGuwahati";
      } else {
        return "MonToFri_GuwahatiToNorthGuwahati";
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

  @action
  void setFerryGhat (String s) {
    this.selectedFerryGhat = s;
  }



}