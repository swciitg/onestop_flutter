// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactDetailsModel _$ContactDetailsModelFromJson(Map<String, dynamic> json) =>
    ContactDetailsModel(
      name: json['name'] as String? ?? 'Untitled',
      email: json['email'] as String? ?? 'Unknown',
      contact: json['contact'] as String? ?? '123456789',
    );

Map<String, dynamic> _$ContactDetailsModelToJson(
        ContactDetailsModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'contact': instance.contact,
    };
