// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/services/data_service.dart';

part 'restaurant_store.g.dart';

class RestaurantStore = _RestaurantStore with _$RestaurantStore;

abstract class _RestaurantStore with Store {
  RestaurantModel _selectedRestaurant = RestaurantModel(
      outletName: "NA",
      caption: "NA",
      closingTime: "NA",
      phoneNumber: "NA",
      latitude: 0,
      longitude: 0,
      location: "NA",
      tags: [],
      imageURL: "");

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
    _searchString = str;
    searchResults = ObservableFuture(executeSearch());
    _searchPageHeader = "Showing results for $str";
  }

  @action
  void setSearchHeader(String str) {
    _searchPageHeader = str;
  }

  Future<List<RestaurantModel>> executeSearch() async {
    List<RestaurantModel> allRestaurants = await DataService.getRestaurants();
    List<RestaurantModel> searchResults = [];
    for (var restaurant in allRestaurants) {
      if (restaurant.outletName
          .toLowerCase()
          .contains(_searchString.toLowerCase())) {
        searchResults.add(restaurant);
      } else {
        for (var dish in restaurant.menu) {
          if (dish.itemName
              .toLowerCase()
              .contains(_searchString.toLowerCase())) {
            searchResults.add(restaurant);
          }
        }
      }
    }
    return searchResults;
  }
}
