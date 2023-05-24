// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      username: json['username'] as String,
      rollNumber: json['rollNumber'] as String,
      outlook: json['outlook'] as String,
      gmail: json['gmail'] as String,
      contact: json['contact'] as String,
      emergencyContact: json['emergencyContact'] as String,
      hostel: json['hostel'] as String,
      linkedin: json['linkedin'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'rollNumber': instance.rollNumber,
      'outlook': instance.outlook,
      'gmail': instance.gmail,
      'contact': instance.contact,
      'emergencyContact': instance.emergencyContact,
      'hostel': instance.hostel,
      'linkedin': instance.linkedin,
      'date': instance.date?.toIso8601String(),
      'image': instance.image,
    };
