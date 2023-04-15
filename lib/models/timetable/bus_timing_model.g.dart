// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_timing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusTiming _$BusTimingFromJson(Map<String, dynamic> json) => BusTiming(
      weekend_campusToCity: json['weekend_campusToCity'] as List<dynamic>?,
      id: json['id'] as String,
      busStop: json['busStop'] as String,
      weekdays_campusToCity: (json['weekdays_campusToCity'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
      weekdays_cityToCampus: (json['weekdays_cityToCampus'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
      weekend_cityToCampus: (json['weekend_cityToCampus'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
    );

Map<String, dynamic> _$BusTimingToJson(BusTiming instance) => <String, dynamic>{
      'weekend_campusToCity': instance.weekend_campusToCity,
      'id': instance.id,
      'busStop': instance.busStop,
      'weekdays_campusToCity': instance.weekdays_campusToCity
          ?.map((e) => e.toIso8601String())
          .toList(),
      'weekdays_cityToCampus': instance.weekdays_cityToCampus
          ?.map((e) => e.toIso8601String())
          .toList(),
      'weekend_cityToCampus': instance.weekend_cityToCampus
          ?.map((e) => e.toIso8601String())
          .toList(),
    };
