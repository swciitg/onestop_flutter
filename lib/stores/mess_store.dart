// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mess_store.g.dart';

class MessStore = _MessStore with _$MessStore;

abstract class _MessStore with Store {
  _MessStore() {
    setupReactions();
  }

  @observable
  String selectedDay = getFormattedDay();

  @observable
  String selectedMeal = getMeal();

  // TODO: Return correct meal based on time of the day. Breakfast till 10 AM, Lunch till 2:30PM and then dinner
  static String getMeal() {
    DateTime now = DateTime.now();
    if(now.hour < 10)
      {
        return "Breakfast";
      }
    else if(now.hour < 14)
      {
        return "Lunch";
      }
    else if(now.hour == 14 && now.minute <= 30)
      {
        return "Lunch";
      }
    return "Dinner";
  }

  @observable
  ObservableFuture<String> selectedHostel = ObservableFuture(getSavedHostel());

  @computed
  bool get hostelLoaded => selectedHostel.status == FutureStatus.fulfilled;

  @observable
  MessMenuModel? selectedMessModel;

  static Future<String> getSavedHostel() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('hostel')) {
      return prefs.getString('hostel') ?? "Kameng";
    }
    return "Kameng";
  }

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
    selectedHostel = ObservableFuture.value(s);
  }

  @action
  void setSelectedMessModel(MessMenuModel m) {
    selectedMessModel = m;
  }

  void setupReactions() {
    autorun((_) {
      if (allMessData.status == FutureStatus.fulfilled &&
          selectedHostel.status == FutureStatus.fulfilled) {
        var requiredModel = allMessData.value!.firstWhere(
            (element) => (element.day
                    .toLowerCase()
                    .contains(selectedDay.toLowerCase()) &&
                element.hostel
                    .toLowerCase()
                    .contains(selectedHostel.value!.toLowerCase()) &&
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
