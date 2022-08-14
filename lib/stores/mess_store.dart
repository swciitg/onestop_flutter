import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'mess_store.g.dart';

class MessStore = _MessStore with _$MessStore;

abstract class _MessStore with Store {
  @observable
  String selectedDay = DateFormat("EEE").format(DateTime.now());

  @observable
  String selectedMeal = "Breakfast";

  @observable
  String selectedHostel = "Brahma";

  @action
  void setDay(String s) {
    this.selectedDay = s;
  }

  @action
  void setMeal(String s) {
    this.selectedMeal = s;
  }

  @action
  void setHostel(String s) {
    this.selectedHostel = s;
  }
}
