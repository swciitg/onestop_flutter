import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_dev/models/food/dish_model.dart';

part 'restaurant_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RestaurantModel {
  @JsonKey(defaultValue: "Untitled Restaurant")
  late String name;

  @JsonKey(defaultValue: " ")
  late String caption;

  @JsonKey(defaultValue: "10:00 PM")
  late String closing_time;

  @JsonKey(defaultValue: "2 hrs")
  late String waiting_time;

  @JsonKey(defaultValue: " ")
  late String phone_number;

  @JsonKey(defaultValue: 26.19247153449412)
  late double latitude;

  @JsonKey(defaultValue: 91.6993500129393)
  late double longitude;

  @JsonKey(defaultValue: " ")
  late String address;

  @JsonKey(defaultValue: [])
  late List<String> tags;

  @JsonKey(defaultValue: [])
  late List<DishModel> menu;

  String image;

  RestaurantModel(
      {required this.name,
      required this.caption,
      required this.closing_time,
      required this.waiting_time,
      required this.phone_number,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.tags,
        this.image =  "https://live.staticflickr.com/3281/5813689894_a558bb341f_b.jpg"});

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


  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
