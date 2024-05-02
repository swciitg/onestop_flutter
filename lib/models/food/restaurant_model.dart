// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_dev/models/food/dish_model.dart';

part 'restaurant_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RestaurantModel {
  @JsonKey(defaultValue: "Untitled Restaurant")
  late String outletName;

  @JsonKey(defaultValue: " ")
  late String caption;

  @JsonKey(defaultValue: "10:00 PM")
  late String closingTime;

  @JsonKey(defaultValue: "IIT Guwahati")
  late String location;

  @JsonKey(defaultValue: " ", fromJson: fromJsonPhone, toJson: toJsonPhone)
  late String phoneNumber;

  @JsonKey(defaultValue: 26.19247153449412)
  late double latitude;

  @JsonKey(defaultValue: 91.6993500129393)
  late double longitude;

  @JsonKey(defaultValue: [])
  late List<String> tags;

  @JsonKey(defaultValue: [])
  late List<DishModel> menu;

  @JsonKey(
      defaultValue:
          "https://dw7n6pv5zdng0.cloudfront.net/modules/0001/04/thumb_3251_modules_big.jpeg")
  late String imageURL;

  RestaurantModel(
      {required this.outletName,
      required this.caption,
      required this.closingTime,
      required this.phoneNumber,
      required this.latitude,
      required this.longitude,
      required this.location,
      required this.tags,
      required this.imageURL});

  // RestaurantModel.fromJson(Map<String, dynamic> json) {
  //   name = json['name'] ?? "Unnamed";= "https://live.staticflickr.com/3281/5813689894_a558bb341f_b.jpg"
  //   closing_time = json['closing_time'] ?? "Not Known";
  //   waiting_time = json['waiting_time'] ?? "Not Known";
  //   caption = json['caption'] ?? "Not Known";
  //   phone_number = json['phone_number'] ?? "Not Known";
  //   latitude = json['latitude'] ?? 0.0;
  //   longitude = json['longitude'] ?? 0.0;
  //   address = json['address'] ?? "Not Known";
  //   tags = List<String>.from(json['tags']);
  //   menu = [];
  //   List<dynamic>.from(json['menu']).forEach((element) {
  //     menu.add(DishModel.fromJson(element));
  //   });
  // }

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}

String fromJsonPhone(int i) {
  return i.toString();
}

int toJsonPhone(String x) {
  return int.parse(x);
}
