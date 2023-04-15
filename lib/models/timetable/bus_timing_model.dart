import 'package:json_annotation/json_annotation.dart';

part 'bus_timing_model.g.dart';

@JsonSerializable()
class BusTiming {
  final List<dynamic>? weekend_campusToCity;
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String busStop;

  @JsonKey(defaultValue: [])
  final List<DateTime>? weekdays_campusToCity;

  @JsonKey(defaultValue: [])
  final List<DateTime>? weekdays_cityToCampus;

  @JsonKey(defaultValue: [])
  final List<DateTime>? weekend_cityToCampus;

  BusTiming({
    required this.weekend_campusToCity,
    required this.id,
    required this.busStop,
    required this.weekdays_campusToCity,
    required this.weekdays_cityToCampus,
    required this.weekend_cityToCampus,
  });
  factory BusTiming.fromJson(Map<String, dynamic> json) =>
      _$BusTimingFromJson(json);

  Map<String, dynamic> toJson() => _$BusTimingToJson(this);
}
