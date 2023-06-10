// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayType _$DayTypeFromJson(Map<String, dynamic> json) => DayType(
  fromCampus: (json['fromCampus'] as List<dynamic>)
      .map((e) => DateTime.parse(e as String))
      .toList(),
  toCampus: (json['toCampus'] as List<dynamic>)
      .map((e) => DateTime.parse(e as String))
      .toList(),
);

Map<String, dynamic> _$DayTypeToJson(DayType instance) => <String, dynamic>{
  'fromCampus':
  instance.fromCampus.map((e) => e.toIso8601String()).toList(),
  'toCampus': instance.toCampus.map((e) => e.toIso8601String()).toList(),
};