// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DishModel _$DishModelFromJson(Map<String, dynamic> json) => DishModel(
      name: json['name'] as String? ?? 'Unnamed',
      veg: json['veg'] as bool? ?? false,
      ingredients: json['ingredients'] == null
          ? ' '
          : ingredientsFromJson(json['ingredients'] as List),
      waiting_time: json['waiting_time'] as int? ?? 2,
      price: json['price'] as int? ?? 150,
    );

Map<String, dynamic> _$DishModelToJson(DishModel instance) => <String, dynamic>{
      'name': instance.name,
      'veg': instance.veg,
      'ingredients': ingredientsToJson(instance.ingredients),
      'waiting_time': instance.waiting_time,
      'price': instance.price,
    };
