// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ferry_timing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FerryTiming _$FerryTimingFromJson(Map<String, dynamic> json) => FerryTiming(
      weekend_campusToCity: (json['weekend_campusToCity'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      id: json['id'] as String? ?? '',
      ferryGhat: json['ferryGhat'] as String? ?? '',
      weekdays_campusToCity: (json['weekdays_campusToCity'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      weekdays_cityToCampus: (json['weekdays_cityToCampus'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      weekend_cityToCampus: (json['weekend_cityToCampus'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
    );

Map<String, dynamic> _$FerryTimingToJson(FerryTiming instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ferryGhat': instance.ferryGhat,
      'weekend_campusToCity': instance.weekend_campusToCity
          .map((e) => e.toIso8601String())
          .toList(),
      'weekdays_campusToCity': instance.weekdays_campusToCity
          .map((e) => e.toIso8601String())
          .toList(),
      'weekdays_cityToCampus': instance.weekdays_cityToCampus
          .map((e) => e.toIso8601String())
          .toList(),
      'weekend_cityToCampus': instance.weekend_cityToCampus
          .map((e) => e.toIso8601String())
          .toList(),
    };
