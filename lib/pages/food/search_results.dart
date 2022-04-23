import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/restaurant_model.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/widgets/food/food_search_bar.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_dev/widgets/food/restaurant_tile.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  static String id = "/foodSearchResults";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            FoodSearchBar(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  context.read<RestaurantStore>().getSearchHeader,
                  style: MyFonts.medium.size(18).setColor(kWhite),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<RestaurantModel>>(
                  future: SearchResults(context),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<RestaurantModel>> snapshot) {
                    if (snapshot.hasData) {
                      List<Widget> foodList = snapshot.data!
                          .map(
                            (e) => RestaurantTile(
                              Restaurant_name: e.name,
                              Cuisine_type: e.caption,
                              Waiting_time: 2,
                              Closing_time: e.closing_time,
                              Phone_Number: e.phone_number,
                              Latitude: 0,
                              Longitude: 0,
                              Distance: 2,
                              restaurant_model: e,
                            ),
                          )
                          .toList();
                      return ListView(
                        children: foodList,
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                          child: Text(
                        "An error occurred",
                        style: MyFonts.medium.size(18).setColor(kWhite),
                      ));
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Future<List<RestaurantModel>> ReadJsonData() async {
  final jsondata = await rootBundle.loadString('lib/globals/restaurants.json');
  final list = json.decode(jsondata) as List<dynamic>;
  return list.map((e) => RestaurantModel.fromJson(e)).toList();
}

Future<List<RestaurantModel>> SearchResults(BuildContext context) async {
  List<RestaurantModel> allRestaurants = await ReadJsonData();
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

    final result = fuse.search(context.read<RestaurantStore>().getSearchString);
    if (result.length != 0) {
      searchResults.add(element);
    }
  });
  return searchResults;
}
