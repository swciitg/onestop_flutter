import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/dish_model.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/widgets/food/restaurant/restaurant_tile.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';

import '../../models/food/restaurant_model.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

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
          RestaurantHeader(
            restaurant: restaurantModel,
          ),
          Expanded(
            child: FutureBuilder<List<DishModel>>(
                future: getMenu(restaurantModel),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DishModel>> snapshot) {
                  if (snapshot.hasData) {
                    // print(snapshot.data);
                    List<Widget> foodList = snapshot.data!
                        .map(
                          (e) => FoodTile(
                            dish: e,
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
          ),
        ],
      ),
    );
  }
}

Future<List<DishModel>> getMenu(RestaurantModel restaurantModel) async {
  return await restaurantModel.menu;
}
