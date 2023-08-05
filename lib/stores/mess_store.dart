// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
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
    DateTime now = DateTime.now();
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
  ObservableFuture<String> selectedHostel = ObservableFuture(getSavedHostel()) ;
  @observable
  MealType mealData= MealType(id: 'id', mealDescription: 'mealDescription', startTiming: DateTime.now(), endTiming: DateTime.now());
  @computed
  bool get hostelLoaded => selectedHostel.status == FutureStatus.fulfilled;
  @action
  void setDay(String s) {
    selectedDay = s;
  }
  @action
  void setMeal(String s) {
    selectedMeal = s;
  }
  @action
  void setHostel(String s)  {
    selectedHostel = ObservableFuture.value(s);
    print(selectedHostel.value);
    print("___________________________________");
  }
  @action
  void setmealData(MealType m)   {
    mealData =  m;
  }
  void setupReactions() async {
    autorun((_) async{
      if(selectedHostel.status == FutureStatus.fulfilled){
        print("selected hostel");
        print(selectedHostel.value);
        // MealType requiredModel = await APIService().getMealData(selectedHostel.value! , selectedDay, selectedMeal);
        MealType requiredModel = await DataProvider.getMealData(hostel:selectedHostel.value!, day: selectedDay,mealType: selectedMeal );
        print(requiredModel.toJson());
        setmealData(requiredModel);
      }else{
        print("else selected hostel");
        // MealType requiredModel = await APIService().getMealData('kameng' , 'Monday', 'Breakfast');
        MealType requiredModel = await DataProvider.getMealData(hostel:'kameng', day: 'monday',mealType: 'breakfast' );
        print(requiredModel.toJson());
        setmealData(requiredModel);
      }
    });
  }

  static Future<String> getSavedHostel() async{
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('hostel')) {
      if(prefs.getString('hostel') == "Subansiri" || prefs.getString('hostel') == "Subhansiri")
      if(prefs.getString('hostel')=="Brahma"){
        return 'Brahmaputra';
      }
      return prefs.getString('hostel') ?? "Kameng";
    }
    return "Kameng";
  }
}