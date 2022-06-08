import 'package:json_annotation/json_annotation.dart';
part 'dish_model.g.dart';

@JsonSerializable()
class DishModel {
  @JsonKey(defaultValue: "Unnamed")
  late String name;
  @JsonKey(defaultValue: false)
  late bool veg;
  @JsonKey(defaultValue: " ",fromJson: ingredientsFromJson, toJson: ingredientsToJson)
  late String ingredients;
  @JsonKey(defaultValue: 2)
  late int waiting_time;
  @JsonKey(defaultValue: 150)
  late int price;

  String image;


  DishModel(
      {required this.name,
      required this.veg,
      required this.ingredients,
      required this.waiting_time,
      required this.price,
      this.image= "https://d4t7t8y8xqo0t.cloudfront.net/resized/750X436/eazytrendz%2F3070%2Ftrend20210218124824.jpg"});

  factory DishModel.fromJson(Map<String, dynamic> json) => _$DishModelFromJson(json);

  Map<String, dynamic> toJson() => _$DishModelToJson(this);

  // DishModel.fromJson(Map<String, dynamic> json) {
  //   name = json['name'] ?? "Unnamed";
  //   veg = json['veg'] ?? "Unnamed";
  //   ingredients = json['ingredients'].toString();
  //   waiting_time = json['waiting_time'] ?? "Not Known";
  //   price = json['price'] ?? "Not Known";
  // }
}

String ingredientsFromJson(List<dynamic> ing) {
  return ing.toString();
}

List<String> ingredientsToJson(String ing) {
  ing = ing.substring(1,ing.length-1);
  return ing.split(',').toList();
}