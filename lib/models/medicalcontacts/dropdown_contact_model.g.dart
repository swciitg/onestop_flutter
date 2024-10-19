// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DropdownContactModel _$DropdownContactModelFromJson(
        Map<String, dynamic> json) =>
    DropdownContactModel(
      name: json['name'] as String? ?? 'Untitled',
      degree: json['degree'] as String? ?? 'Untitled',
      designation: json['designation'] as String? ?? 'Untitled',
    );

Map<String, dynamic> _$DropdownContactModelToJson(
        DropdownContactModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'degree': instance.degree,
      'designation': instance.designation,
    };
