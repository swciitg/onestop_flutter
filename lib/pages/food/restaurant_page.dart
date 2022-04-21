import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/dish_model.dart';
import 'package:onestop_dev/widgets/food/restaurant_tile.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import '../../models/restaurant_model.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: RestaurantHeader(
              Restaurant_Name: "Florentine Restaurant ",
              About: "Multicusine,Dine-in",
              Address: "29 West",
              Veg: false,
              Closing_Time: 10,
              Waiting_Time: 2,
              Distance: 2,
              Phone_Number: "1234567890",
              Longitude: 54.330,
              Latitude: -127.300,
            ),
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder<List<DishModel>>(
                future: ReadJsonData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DishModel>> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    List<Widget> foodList = snapshot.data!
                        .map((e) => FoodTile(
                              Dish_Name: e.name,
                              Ingredients: ["Something", "Something"],
                              Waiting_time: e.waiting_time,
                              Price: e.price,
                              Veg: e.veg,
                            ))
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

Future<List<DishModel>> ReadJsonData() async {
  String restaurantSelected = "Florentine";
  final jsondata = await rootBundle.loadString('lib/globals/restaurants.json');
  final list = json.decode(jsondata) as List<dynamic>;
  List<RestaurantModel> allRestaurants =  list.map((e) => RestaurantModel.fromJson(e)).toList();
  allRestaurants = allRestaurants.where((element) => element.name.contains(restaurantSelected)).toList();
  print("All restaurants is ${allRestaurants.toString()}");
  return allRestaurants.elementAt(0).menu;
}
