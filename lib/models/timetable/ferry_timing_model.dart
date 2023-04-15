import 'dart:convert';

List<FerryTiming> ferryTimingFromJson(String str) => List<FerryTiming>.from(
    json.decode(str).map((x) => FerryTiming.fromJson(x)));

String ferryTimingToJson(List<FerryTiming> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FerryTiming {
  FerryTiming({
    required this.weekendCampusToCity,
    required this.id,
    required this.ferryGhat,
    required this.weekdaysCampusToCity,
    required this.weekdaysCityToCampus,
    required this.weekendCityToCampus,
  });

  List<dynamic> weekendCampusToCity;
  String id;
  String ferryGhat;
  List<DateTime> weekdaysCampusToCity;
  List<DateTime> weekdaysCityToCampus;
  List<DateTime> weekendCityToCampus;

  factory FerryTiming.fromJson(Map<dynamic, dynamic> json) => FerryTiming(
        weekendCampusToCity:
            List<dynamic>.from(json["weekend_campusToCity"].map((x) => x)),
        id: json["_id"],
        ferryGhat: json["ferryGhat"],
        weekdaysCampusToCity: List<DateTime>.from(
            json["weekdays_campusToCity"].map((x) => DateTime.parse(x))),
        weekdaysCityToCampus: List<DateTime>.from(
            json["weekdays_cityToCampus"].map((x) => DateTime.parse(x))),
        weekendCityToCampus: List<DateTime>.from(
            json["weekend_cityToCampus"].map((x) => DateTime.parse(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "weekend_campusToCity":
            List<dynamic>.from(weekendCampusToCity.map((x) => x)),
        "_id": id,
        "ferryGhat": ferryGhat,
        "weekdays_campusToCity": List<dynamic>.from(
            weekdaysCampusToCity.map((x) => x.toIso8601String())),
        "weekdays_cityToCampus": List<dynamic>.from(
            weekdaysCityToCampus.map((x) => x.toIso8601String())),
        "weekend_cityToCampus": List<dynamic>.from(
            weekendCityToCampus.map((x) => x.toIso8601String())),
      };
}
