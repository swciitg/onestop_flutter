import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/food/favourite_dishes.dart';
import 'package:onestop_dev/widgets/food/food_search_bar.dart';
import 'package:onestop_dev/widgets/food/mess/mess_menu.dart';
import 'package:onestop_dev/widgets/food/outlets_filter.dart';
import 'package:onestop_dev/widgets/food/restaurant/restaurant_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';

class FoodTab extends StatelessWidget {
  const FoodTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          FoodSearchBar(),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MessMenu(),
                  SizedBox(height: 16),
                  FavoriteDishes(),
                  SizedBox(
                    height: 16,
                  ),
                  OutletsFilter(),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<RestaurantModel>>(
                      future: ReadJsonData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<RestaurantModel>> snapshot) {
                        if (snapshot.hasData) {
                          // print(snapshot.data);
                          List<Widget> foodList = snapshot.data!
                              .map(
                                (e) => RestaurantTile(
                                  restaurant_model: e,
                                ),
                              )
                              .toList();
                          return Column(
                            children: foodList,
                          );
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return Center(
                              child: Text(
                            "An error occurred",
                            style: MyFonts.w500.size(18).setColor(kWhite),
                          ));
                        }
                        return Center(
                          child: ListShimmer(height: 168,),
                        );
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<RestaurantModel>> ReadJsonData() async {
  List<RestaurantModel> l = await DataProvider.getRestaurants();
  return l;
}
