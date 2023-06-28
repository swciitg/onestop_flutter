// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DishModel _$DishModelFromJson(Map<String, dynamic> json) => DishModel(
      itemName: json['itemName'] as String? ?? 'Unnamed',
      price: json['price'] as int? ?? 2,
      imageURL: json['imageURL'] as String? ??
          "https://d4t7t8y8xqo0t.cloudfront.net/resized/750X436/eazytrendz%2F3070%2Ftrend20210218124824.jpg",
    );

Map<String, dynamic> _$DishModelToJson(DishModel instance) => <String, dynamic>{
      'itemName': instance.itemName,
      'price': instance.price,
      'imageURL': instance.imageURL,
    };
