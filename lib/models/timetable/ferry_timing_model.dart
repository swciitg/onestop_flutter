import 'package:json_annotation/json_annotation.dart';

part 'ferry_timing_model.g.dart';

@JsonSerializable()
class FerryTiming {
  FerryTiming({
    required this.weekend_campusToCity,
    required this.id,
    required this.ferryGhat,
    required this.weekdays_campusToCity,
    required this.weekdays_cityToCampus,
    required this.weekend_cityToCampus,
  });

  @JsonKey(defaultValue: '')
  String id;

  @JsonKey(defaultValue: '')
  String ferryGhat;

  @JsonKey(defaultValue: [])
  List<DateTime> weekend_campusToCity;

  @JsonKey(defaultValue: [])
  List<DateTime> weekdays_campusToCity;

  @JsonKey(defaultValue: [])
  List<DateTime> weekdays_cityToCampus;

  @JsonKey(defaultValue: [])
  List<DateTime> weekend_cityToCampus;

  factory FerryTiming.fromJson(Map<String, dynamic> json) =>
      _$FerryTimingFromJson(json);

  Map<String, dynamic> toJson() => _$FerryTimingToJson(this);
}
