// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DayType {
  final List<DateTime> fromCampus;
  final List<DateTime> toCampus;

  const DayType({
    required this.fromCampus,
    required this.toCampus,
  });

  static int _compareTimings(DateTime a, DateTime b) {
    final a1 = DateTime(2000, 1, 1, a.hour, a.minute);
    final b1 = DateTime(2000, 1, 1, b.hour, b.minute);

    return a1.compareTo(b1);
  }

  factory DayType.fromJson(Map<String, dynamic> json) {
    final fromCampus = (json['fromCampus'] as List<dynamic>)
        .map((e) => DateTime.parse(e as String))
        .toList();
    final toCampus = (json['toCampus'] as List<dynamic>)
        .map((e) => DateTime.parse(e as String))
        .toList();

    fromCampus.sort(_compareTimings);
    toCampus.sort(_compareTimings);

    return DayType(
      fromCampus: fromCampus,
      toCampus: toCampus,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fromCampus': fromCampus.map((e) => e.toIso8601String()).toList(),
        'toCampus': toCampus.map((e) => e.toIso8601String()).toList(),
      };
}
