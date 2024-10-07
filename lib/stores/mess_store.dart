// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mess_store.g.dart';

class MessStore = _MessStore with _$MessStore;

abstract class _MessStore with Store {
  _MessStore() {
    setupReactions();
  }

  @observable
  String selectedDay = getFormattedDayForMess();
  @observable
  String selectedMeal = getMeal();

  static String getMeal() {
    DateTime now = DateTime.now().toLocal();
    if (now.hour < 10) {
      return "Breakfast";
    } else if (now.hour < 14) {
      return "Lunch";
    } else if (now.hour == 14 && now.minute <= 30) {
      return "Lunch";
    }
    return "Dinner";
  }

  @observable
  ObservableFuture<Mess> selectedMess = ObservableFuture(getSavedMess());
  @observable
  MealType mealData = MealType(
      id: 'id',
      mealDescription: 'mealDescription',
      startTiming: DateTime.now().toLocal(),
      endTiming: DateTime.now().toLocal());

  @computed
  bool get messLoaded => selectedMess.status == FutureStatus.fulfilled;

  static Mess defaultMess = Mess.kameng;

  @computed
  Mess get defaultUserMess => defaultMess;

  @action
  void setDay(String s) {
    selectedDay = s;
  }

  @action
  void setMeal(String s) {
    selectedMeal = s;
  }

  @action
  void setMess(Mess m) {
    selectedMess = ObservableFuture.value(m);
  }

  @action
  void setMealData(MealType m) {
    mealData = m;
  }

  void setupReactions() async {
    autorun((_) async {
      if (selectedMess.status == FutureStatus.fulfilled) {
        MealType requiredModel = await DataProvider.getMealData(
            mess: selectedMess.value!,
            day: selectedDay,
            mealType: selectedMeal);
        setMealData(requiredModel);
      } else {
        MealType requiredModel = await DataProvider.getMealData(
            mess: defaultMess, day: selectedDay, mealType: selectedMeal);
        setMealData(requiredModel);
      }
    });
  }

  static Future<Mess> getSavedMess() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('subscribedMess')) {
      final mess = prefs.getString('subscribedMess');
      if (mess == Mess.none.databaseString || mess == null) {
        return defaultMess;
      }
      return mess.getMessFromDatabaseString()!;
    }
    return defaultMess;
  }

  Future<Map<String, dynamic>> postMessSubChange(
      Map<String, dynamic> data) async {
    final res = await APIService().postMessSubChange(data);
    return res;
  }

  Future<Map<String, dynamic>> postMessOpi(Map<String, dynamic> data) async {
    final res = await APIService().postMessOpi(data);
    return res;
  }
}
