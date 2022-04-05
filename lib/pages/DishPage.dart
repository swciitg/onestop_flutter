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
              child: FutureBuilder<List<RestaurantModel>>(
                future: ReadJsonData(),
                builder:(BuildContext context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    List<Widget> foodList = snapshot.data!.map((e)=>FoodResTile(Restaurant_name: e.name, Cuisine_type: e.caption, Wating_time: 2, Closing_time: e.closing_time, distance: 2)).toList();
                    return ListView(
                      children: foodList,
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text(
                      "An error occurred",
                      style: MyFonts.medium.size(18).setColor(kWhite),
                    ));
                  }
                  return Center(child: CircularProgressIndicator(color: Colors.white,),);
                }
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
  final jsondata = await rootBundle.loadString('lib/globals/restaurants.json');
  final list = json.decode(jsondata) as List<dynamic>;

  return list.map((e) => RestaurantModel.fromJson(e)).toList();
}
