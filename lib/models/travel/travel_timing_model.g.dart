// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_timing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelTiming _$TravelTimingFromJson(Map<String, dynamic> json) => TravelTiming(
      type: json['type'] as String? ?? '',
      id: json['_id'] as String,
      stop: json['stop'] as String? ?? '',
      weekend:  DayType.fromJson(json['weekend'] as Map<String, dynamic>),
      weekdays:DayType.fromJson(json['weekdays'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TravelTimingToJson(TravelTiming instance) =>
    <String, dynamic>{
          '_id': instance.id,
          'type': instance.type,
          'stop': instance.stop,
          'weekend': instance.weekend,
          'weekdays': instance.weekdays,
    };