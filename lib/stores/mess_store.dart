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
  ObservableFuture<Hostel> selectedHostel = ObservableFuture(getSavedHostel());
  @observable
  MealType mealData = MealType(
      id: 'id',
      mealDescription: 'mealDescription',
      startTiming: DateTime.now().toLocal(),
      endTiming: DateTime.now().toLocal());

  @computed
  bool get hostelLoaded => selectedHostel.status == FutureStatus.fulfilled;

  static Hostel defaultHostel = Hostel.kameng;

  @computed
  Hostel get defaultUserHostel => defaultHostel;

  @action
  void setDay(String s) {
    selectedDay = s;
  }

  @action
  void setMeal(String s) {
    selectedMeal = s;
  }

  @action
  void setHostel(Hostel h) {
    selectedHostel = ObservableFuture.value(h);
  }

  @action
  void setMealData(MealType m) {
    mealData = m;
  }

  void setupReactions() async {
    autorun((_) async {
      if (selectedHostel.status == FutureStatus.fulfilled) {
        MealType requiredModel = await DataProvider.getMealData(
            hostel: selectedHostel.value!,
            day: selectedDay,
            mealType: selectedMeal);
        setMealData(requiredModel);
      } else {
        MealType requiredModel = await DataProvider.getMealData(
            hostel: defaultHostel, day: selectedDay, mealType: selectedMeal);
        setMealData(requiredModel);
      }
    });
  }

  static Future<Hostel> getSavedHostel() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('hostel')) {
      final hostel = prefs.getString('hostel');
      if (hostel == Hostel.msh.databaseString || hostel == null) {
        return defaultHostel;
      }
      return hostel.getHostelFromDatabaseString()!;
    }
    return defaultHostel;
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
