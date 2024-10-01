// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicalcontact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalcontactModel _$MedicalcontactModelFromJson(Map<String, dynamic> json) =>
    MedicalcontactModel(
      name: DropdownContactModel.fromJson(json['name'] as Map<String, dynamic>),
      email: json['email'] as String? ?? 'Unknown',
      phone: json['phone'] as String? ?? '123456789',
      category: json['category'] as String? ?? 'Untitled',
      designation: json['designation'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
    );

Map<String, dynamic> _$MedicalcontactModelToJson(
        MedicalcontactModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'email': instance.email,
      'phone': instance.phone,
      'designation': instance.designation,
      'degree': instance.degree,
    };
