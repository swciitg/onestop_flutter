import 'package:flutter/cupertino.dart';

class DishModel {
  late String name;
  late bool veg;
  // late List<String> ingredients;
  late int waiting_time;
  late int price;

  DishModel(
      {required this.name,
      required this.veg,
      // required this.ingredients,
      required this.waiting_time,
      required this.price});

  DishModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "Unnamed";
    veg = json['veg'] ?? "Unnamed";
    // ingredients = json['ingredients'] ?? "Not Known";
    waiting_time = json['waiting_time'] ?? "Not Known";
    price = json['price'] ?? "Not Known";
  }
}
