// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(
  Map<String, dynamic> json,
) => RestaurantModel(
    outletName: json['outletName'] as String? ?? 'Untitled Restaurant',
    caption: json['caption'] as String? ?? ' ',
    closingTime: json['closingTime'] as String? ?? '10:00 PM',
    phoneNumber:
        json['phoneNumber'] == null
            ? ' '
            : fromJsonPhone((json['phoneNumber'] as num).toInt()),
    latitude: (json['latitude'] as num?)?.toDouble() ?? 26.19247153449412,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 91.6993500129393,
    location: json['location'] as String? ?? 'IIT Guwahati',
    tags:
        (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    imageURL:
        json['imageURL'] as String? ??
        'https://dw7n6pv5zdng0.cloudfront.net/modules/0001/04/thumb_3251_modules_big.jpeg',
  )
  ..menu =
      (json['menu'] as List<dynamic>?)
          ?.map((e) => DishModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) =>
    <String, dynamic>{
      'outletName': instance.outletName,
      'caption': instance.caption,
      'closingTime': instance.closingTime,
      'location': instance.location,
      'phoneNumber': toJsonPhone(instance.phoneNumber),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'tags': instance.tags,
      'menu': instance.menu.map((e) => e.toJson()).toList(),
      'imageURL': instance.imageURL,
    };
