// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map<String, dynamic> json) =>
    RestaurantModel(
      name: json['name'] as String? ?? 'Untitled Restaurant',
      caption: json['caption'] as String? ?? ' ',
      closing_time: json['closing_time'] as String? ?? '10:00 PM',
      waiting_time: json['waiting_time'] as String? ?? '2 hrs',
      phone_number: json['phone_number'] as String? ?? ' ',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 26.19247153449412,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 91.6993500129393,
      address: json['address'] as String? ?? ' ',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      image: json['image'] as String? ??
          "https://live.staticflickr.com/3281/5813689894_a558bb341f_b.jpg",
    )..menu = (json['menu'] as List<dynamic>?)
            ?.map((e) => DishModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'caption': instance.caption,
      'closing_time': instance.closing_time,
      'waiting_time': instance.waiting_time,
      'phone_number': instance.phone_number,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'tags': instance.tags,
      'menu': instance.menu.map((e) => e.toJson()).toList(),
      'image': instance.image,
    };
