import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'travel_store.g.dart';

class TravelStore = _TravelStore with _$TravelStore;

abstract class _TravelStore with Store {
  @observable
  int selectBusesorStops = 0;

  @computed
  List<Widget> get busPage {
    int timetableIndex = 0;
    List<Widget> l = [];
    return l;
  }

}