// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicalcontact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalcontactModel _$MedicalcontactModelFromJson(Map<String, dynamic> json) =>
    MedicalcontactModel(
      name: json['name'] as String? ?? 'Untitled',
      email: json['email'] as String? ?? 'Unknown',
      contact: json['contact'] as String? ?? '123456789',
      category: json['category'] as String? ?? 'Untitled',
      designation: json['designation'] as String? ?? 'Untitled',
      degree: json['degree'] as String? ?? 'Untitled',
    );

Map<String, dynamic> _$MedicalcontactModelToJson(
        MedicalcontactModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'email': instance.email,
      'contact': instance.contact,
      'designation': instance.designation,
      'degree': instance.degree,
    };
