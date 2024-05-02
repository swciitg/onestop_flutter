import 'package:json_annotation/json_annotation.dart';

part 'dish_model.g.dart';

// ignore_for_file: non_constant_identifier_names
@JsonSerializable()
class DishModel {
  @JsonKey(defaultValue: "Unnamed")
  late String itemName;
  @JsonKey(defaultValue: 2)
  late int price;
  String imageURL;

  DishModel(
      {required this.itemName,
      required this.price,
      this.imageURL =
          "https://d4t7t8y8xqo0t.cloudfront.net/resized/750X436/eazytrendz%2F3070%2Ftrend20210218124824.jpg"});

  factory DishModel.fromJson(Map<String, dynamic> json) =>
      _$DishModelFromJson(json);

  Map<String, dynamic> toJson() => _$DishModelToJson(this);

  // DishModel.fromJson(Map<String, dynamic> json) {
  //   name = json['name'] ?? "Unnamed";
  //   veg = json['veg'] ?? "Unnamed";
  //   ingredients = json['ingredients'].toString();
  //   waiting_time = json['waiting_time'] ?? "Not Known";
  //   price = json['price'] ?? "Not Known";
  // }
}
