// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'found_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoundModel _$FoundModelFromJson(Map<String, dynamic> json) => FoundModel(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      imageURL: json['imageURL'] as String,
      compressedImageURL: json['compressedImageURL'] as String,
      date: DateTime.parse(json['date'] as String),
      submittedat: json['submittedat'] as String,
    );

Map<String, dynamic> _$FoundModelToJson(FoundModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'compressedImageURL': instance.compressedImageURL,
      'date': instance.date.toIso8601String(),
      'submittedAt': instance.submittedat,
    };
