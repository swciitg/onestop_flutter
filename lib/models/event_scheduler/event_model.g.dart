// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageURL: json['imageURL'] as String,
      compressedImageURL: json['compressedImageURL'] as String,
      date: DateTime.parse(json['date'] as String),
      club_org: json['club_org'] as String,
      venue: json['venue'] as String,
      contactNumber: json['contactNumber'] as String,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'compressedImageURL': instance.compressedImageURL,
      'date': instance.date.toIso8601String(),
      'club_org': instance.club_org,
      'venue': instance.venue,
      'contactNumber': instance.contactNumber,
    };
