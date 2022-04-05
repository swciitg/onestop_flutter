import 'package:flutter/cupertino.dart';

class RestaurantModel{
  late String name;
  late String caption;
  late String closing_time;
  late String waiting_time;
  late String phone_number;
  


  RestaurantModel(
      {
        required this.name,
        required this.caption,
        required this.closing_time,
        required this.waiting_time,
        required this.phone_number
      });


  RestaurantModel.fromJson(Map<String,dynamic> json)
  {
    name =json['name']??"Unnamed";
    closing_time = json['closing_time']??"Not Known";
    waiting_time = json['waiting_time']??"Not Known";
    caption = json['caption']??"Not Known";
    phone_number = json['phone_number']??"Not Known";
  }
}