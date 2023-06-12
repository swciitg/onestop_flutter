// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      name: json['name'] as String,
      rollNo: json['rollNo'] as String,
      outlookEmail: json['outlookEmail'] as String,
      altEmail: json['altEmail'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      emergencyPhoneNumber: json['emergencyPhoneNumber'] as String?,
      gender: json['gender'] as String?,
      roomNo: json['roomNo'] as String?,
      homeAddress: json['homeAddress'] as String?,
      dob: json['dob'] as String?,
      hostel: json['hostel'] as String?,
      linkedin: json['linkedin'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rollNo': instance.rollNo,
      'outlookEmail': instance.outlookEmail,
      'altEmail': instance.altEmail,
      'phoneNumber': instance.phoneNumber,
      'emergencyPhoneNumber': instance.emergencyPhoneNumber,
      'gender': instance.gender,
      'roomNo': instance.roomNo,
      'homeAddress': instance.homeAddress,
      'dob': instance.dob,
      'hostel': instance.hostel,
      'linkedin': instance.linkedin,
      'image': instance.image,
    };
