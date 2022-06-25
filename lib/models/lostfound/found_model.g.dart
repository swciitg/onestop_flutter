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
      claimed: json['claimed'] as bool,
      claimerEmail: json['claimerEmail'] as String,
      claimerName: json['claimerName'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$FoundModelToJson(FoundModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'compressedImageURL': instance.compressedImageURL,
      'date': instance.date.toIso8601String(),
      'submittedat': instance.submittedat,
      'claimed': instance.claimed,
      'claimerEmail': instance.claimerEmail,
      'claimerName': instance.claimerName,
      '_id': instance.id,
    };
