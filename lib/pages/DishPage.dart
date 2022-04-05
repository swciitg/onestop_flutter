import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';
import 'package:onestop_dev/models/restaurantmodel.dart';
import 'package:onestop_dev/widgets/appbar.dart';
import 'package:onestop_dev/widgets/foodResTile.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DishPage extends StatelessWidget {
  const DishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
          SizedBox(
            height: 8,
          ),
          FoodSearchBar(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Biryani",
                style: MyFonts.medium.size(18).setColor(kWhite),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              FoodResTile(
                Restaurant_name: "Florentine Restaurant",
                Cuisine_type: 'Multicuisine, dine-in,\nnorth-Indian',
                Wating_time: 2,
                Closing_time: '10:00pm',
                distance: 2,
              ),
              FoodResTile(
                Restaurant_name: "Brahma Canteen",
                Cuisine_type: 'Multicuisine, dine-in,\nnorth-Indian',
                Wating_time: 1,
                Closing_time: '10:00pm',
                distance: 2,
              )
            ],
          ))
        ]),
      ),
    );
  }
}

class FoodSearchBar extends StatelessWidget {
  const FoodSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: kWhite,
          ),
          hintStyle: MyFonts.medium.setColor(kGrey2),
          hintText: "Search dish or restaurant",
          fillColor: kBlueGrey),
    );
  }
}

Future<List<RestaurantModel>> ReadJsonData() async {
  final jsondata = await rootBundle.loadString('globals/restaurants.json');
  final list = json.decode(jsondata) as List<dynamic>;

  return list.map((e) => RestaurantModel.fromJson(e)).toList();
}
