// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/services/api.dart';
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
  String selectedFerryGhat = "Mazgaon";

  @observable
  ObservableFuture<List<TravelTiming>> ferryTimings =
  ObservableFuture(APIService().getFerryTiming());

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
      return const BusStopList();
    }
    return BusDetails(index: busDayTypeIndex);
  }

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