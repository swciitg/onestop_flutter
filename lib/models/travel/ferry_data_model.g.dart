// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ferry_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FerryTimeData _$FerryTimeDataFromJson(Map<String, dynamic> json) =>
    FerryTimeData(
      json['name'] as String,
      (json['MonToFri_GuwahatiToNorthGuwahati'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['MonToFri_NorthGuwahatiToGuwahati'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['Sunday_GuwahatiToNorthGuwahati'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['Sunday_NorthGuwahatiToGuwahati'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FerryTimeDataToJson(FerryTimeData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'MonToFri_GuwahatiToNorthGuwahati':
          instance.MonToFri_GuwahatiToNorthGuwahati,
      'MonToFri_NorthGuwahatiToGuwahati':
          instance.MonToFri_NorthGuwahatiToGuwahati,
      'Sunday_GuwahatiToNorthGuwahati': instance.Sunday_GuwahatiToNorthGuwahati,
      'Sunday_NorthGuwahatiToGuwahati': instance.Sunday_NorthGuwahatiToGuwahati,
    };
