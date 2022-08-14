// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyModel _$BuyModelFromJson(Map<String, dynamic> json) => BuyModel(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      imageURL: json['imageURL'] as String,
      compressedImageURL: json['compressedImageURL'] as String,
      date: DateTime.parse(json['date'] as String),
      phonenumber: json['phonenumber'] as String,
      price: json['price'] as String,
    );

Map<String, dynamic> _$BuyModelToJson(BuyModel instance) => <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'compressedImageURL': instance.compressedImageURL,
      'phonenumber': instance.phonenumber,
      'price': instance.price,
      'date': instance.date.toIso8601String(),
    };
