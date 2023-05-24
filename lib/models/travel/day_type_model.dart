// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'day_type_model.g.dart';

@JsonSerializable()
class DayType {
  final List<DateTime> fromCampus;
  final List<DateTime> toCampus;
  DayType(
      {
        required this.fromCampus,
        required this.toCampus,
      }
      );
  factory DayType.fromJson(Map<String, dynamic> json) =>
      _$DayTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DayTypeToJson(this);
}
