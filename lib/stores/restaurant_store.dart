import 'package:fuzzy/fuzzy.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/services/data_provider.dart';

part 'restaurant_store.g.dart';

class RestaurantStore = _RestaurantStore with _$RestaurantStore;

abstract class _RestaurantStore with Store {
  RestaurantModel _selectedRestaurant = RestaurantModel(
      name: "NA",
      caption: "NA",
      closing_time: "NA",
      waiting_time: "NA",
      phone_number: "NA",
      latitude: 0,
      longitude: 0,
      address: "NA",
      tags: []);

  @observable
  String _searchString = "";


  @observable
  String _searchPageHeader =
      ""; // Use this only when user clicks on Your Favourite Dishes

  @observable
  ObservableFuture<List<RestaurantModel>> searchResults =
      ObservableFuture.value([]);

  RestaurantModel get getSelectedRestaurant => _selectedRestaurant;
  String get getSearchString => _searchString;
  String get getSearchHeader => _searchPageHeader;

  @action
  void setSelectedRestaurant(RestaurantModel r) {
    _selectedRestaurant = r;
  }

  @action
  void setSearchString(String str) {
    print("Search String set to $str");
    _searchString = str;
    searchResults = ObservableFuture(SearchResults());
    _searchPageHeader = "Showing results for $str";
  }

  @action
  void setSearchHeader(String str) {
    _searchPageHeader = str;
  }

  Future<List<RestaurantModel>> SearchResults() async {
    List<RestaurantModel> allRestaurants = await DataProvider.getRestaurants();
    List<RestaurantModel> searchResults = [];
    allRestaurants.forEach((element) {
      List<String> searchFields = element.tags;
      element.menu.forEach((dish) {
        searchFields.add(dish.name);
      });
      final fuse = Fuzzy(
        searchFields,
        options: FuzzyOptions(
          findAllMatches: false,
          tokenize: false,
          threshold: 0.4,
        ),
      );

      final result = fuse.search(_searchString);
      if (result.length != 0) {
        searchResults.add(element);
      }
    });
    return searchResults;
  }
}
