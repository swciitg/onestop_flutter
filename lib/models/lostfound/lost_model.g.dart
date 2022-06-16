// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LostModel _$LostModelFromJson(Map<String, dynamic> json) => LostModel(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      imageURL: json['imageURL'] as String,
      compressedImageURL: json['compressedImageURL'] as String,
      date: DateTime.parse(json['date'] as String),
      phonenumber: json['phonenumber'] as String,
    );

Map<String, dynamic> _$LostModelToJson(LostModel instance) => <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'compressedImageURL': instance.compressedImageURL,
      'phonenumber': instance.phonenumber,
      'date': instance.date.toIso8601String(),
    };
