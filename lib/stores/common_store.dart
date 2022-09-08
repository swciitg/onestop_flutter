// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'common_store.g.dart';

class CommonStore = _CommonStore with _$CommonStore;

abstract class _CommonStore with Store {
  @observable
  String lnfIndex = "Lost";

  @observable
  String bnsIndex = "Sell";

  @action
  void setLnfIndex(String newIndex) {
    lnfIndex = newIndex;
  }

  @action
  void setBnsIndex(String newIndex) {
    bnsIndex = newIndex;
  }

  int get pageSize => 5;
}
