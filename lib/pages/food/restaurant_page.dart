import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/dish_model.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/widgets/food/restaurant_tile.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';
import '../../models/restaurant_model.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RestaurantModel r = context.read<RestaurantStore>().getSelectedRestaurant;
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RestaurantHeader(
            restaurant: r,
          ),
          Expanded(
            child: FutureBuilder<List<DishModel>>(
                future: ReadJsonData(r.name),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DishModel>> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
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

Future<List<DishModel>> ReadJsonData(String restaurantName) async {
  String restaurantSelected = restaurantName;
  final jsondata = await rootBundle.loadString('lib/globals/restaurants.json');
  final list = json.decode(jsondata) as List<dynamic>;
  List<RestaurantModel> allRestaurants =
      list.map((e) => RestaurantModel.fromJson(e)).toList();
  allRestaurants = allRestaurants
      .where((element) => element.name.contains(restaurantSelected))
      .toList();
  print("All restaurants is ${allRestaurants.toString()}");
  return allRestaurants.elementAt(0).menu;
}
