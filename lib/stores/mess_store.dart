// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/services/data_provider.dart';

part 'mess_store.g.dart';

class MessStore = _MessStore with _$MessStore;

abstract class _MessStore with Store {
  _MessStore() {
    setupReactions();
  }

  @observable
  String selectedDay = getFormattedDay();

  @observable
  String selectedMeal = "Breakfast";

  @observable
  String selectedHostel = "Kameng";

  @observable
  MessMenuModel? selectedMessModel;

  @observable
  ObservableFuture<List<MessMenuModel>> allMessData =
      ObservableFuture(DataProvider.getMessMenu());

  @action
  void setDay(String s) {
    selectedDay = s;
  }

  @action
  void setMeal(String s) {
    selectedMeal = s;
  }

  @action
  void setHostel(String s) {
    selectedHostel = s;
  }

  @action
  void setSelectedMessModel(MessMenuModel m) {
    selectedMessModel = m;
  }

  void setupReactions() {
    autorun((_) {
      if (allMessData.status == FutureStatus.fulfilled) {
        var requiredModel = allMessData.value!.firstWhere(
            (element) => (element.day
                    .toLowerCase()
                    .contains(selectedDay.toLowerCase()) &&
                element.hostel
                    .toLowerCase()
                    .contains(selectedHostel.toLowerCase()) &&
                element.meal.toLowerCase() == selectedMeal.toLowerCase()),
            orElse: () => MessMenuModel(
                hostel: "",
                meal: "",
                menu: "Will update soon",
                day: "",
                timing: "Oh no!"));
        setSelectedMessModel(requiredModel);
      }
    });
  }
}
