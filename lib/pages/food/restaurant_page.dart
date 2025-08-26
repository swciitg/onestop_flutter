import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/dish_model.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/widgets/food/restaurant/food_tile.dart';
import 'package:onestop_dev/widgets/food/restaurant/restaurant_header.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

import '../../models/food/restaurant_model.dart';
import '../../widgets/ui/list_shimmer.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantModel restaurantModel =
        context.read<RestaurantStore>().getSelectedRestaurant;
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RestaurantHeader(restaurant: restaurantModel),
          Expanded(
            child: FutureBuilder<List<DishModel>>(
              future: getMenu(restaurantModel),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<DishModel>> snapshot,
              ) {
                if (snapshot.hasData) {
                  // print(snapshot.data);
                  List<Widget> foodList =
                      snapshot.data!.map((e) => FoodTile(dish: e)).toList();
                  return ListView(children: foodList);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "An error occurred",
                      style: MyFonts.w500.size(18).setColor(kWhite),
                    ),
                  );
                }
                return Center(child: ListShimmer(height: 130));
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<DishModel>> getMenu(RestaurantModel restaurantModel) async {
  return restaurantModel.menu;
}
