import 'package:json_annotation/json_annotation.dart';

import './day_type_model.dart';

part 'travel_timing_model.g.dart';

@JsonSerializable()
class TravelTiming {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String stop;
  final DayType weekend;
  final DayType weekdays;

  TravelTiming({
    required this.type,
    required this.id,
    required this.stop,
    required this.weekend,
    required this.weekdays,
  });
  factory TravelTiming.fromJson(Map<String, dynamic> json) =>
      _$TravelTimingFromJson(json);

  Map<String, dynamic> toJson() => _$TravelTimingToJson(this);
}
