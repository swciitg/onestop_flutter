import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';
import 'package:onestop_dev/widgets/foodResTile.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBackground,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                RestaurantTile(
                    Restaurant_Name: "Florentine Restaurant",
                    About: "Multicusine,Dine-in",
                    Address: "29 West",
                    Veg: false,
                    Closing_Time: 10,
                    Waiting_Time: 2,
                    Distance: 2,
                    Mobile_Number: "1234567890"),
              ],
            ),
          ),
          FoodTile(
            Dish_Name: "Chicken Biryani",
            Veg: false,
            Ingredients: ["Chicken", "Rice", "Spices"],
            Price: 180,
            Waiting_time: 1,
          )
        ],
      ),
    );
  }
}
