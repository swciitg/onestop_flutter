import 'package:onestop_dev/models/dish_model.dart';

class RestaurantModel {
  late String name;
  late String caption;
  late String closing_time;
  late String waiting_time;
  late String phone_number;
  double? latitude;
  double? longitude;
  late List<String> tags;
  late List<DishModel> menu;

  RestaurantModel(
      {required this.name,
      required this.caption,
      required this.closing_time,
      required this.waiting_time,
      required this.phone_number,
      required this.latitude,
      required this.longitude,
      required this.tags
      });

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "Unnamed";
    closing_time = json['closing_time'] ?? "Not Known";
    waiting_time = json['waiting_time'] ?? "Not Known";
    caption = json['caption'] ?? "Not Known";
    phone_number = json['phone_number'] ?? "Not Known";
    latitude = json['latitude'] ?? 0.0;
    longitude = json['longitude'] ?? 0.0;
    tags = List<String>.from(json['tags']);
    menu = [];
    List<dynamic>.from(json['menu']).forEach((element) {
      menu.add(DishModel.fromJson(element));
    });
  }
}
