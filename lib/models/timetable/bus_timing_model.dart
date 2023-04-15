import 'dart:convert';

List<BusTiming> busTimingFromJson(String str) =>
    List<BusTiming>.from(json.decode(str).map((x) => BusTiming.fromJson(x)));

String busTimingToJson(List<BusTiming> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusTiming {
  BusTiming({
    required this.weekendCampusToCity,
    required this.id,
    required this.busStop,
    required this.weekdaysCampusToCity,
    required this.weekdaysCityToCampus,
    required this.weekendCityToCampus,
  });

  List<dynamic> weekendCampusToCity;
  String id;
  String busStop;
  List<DateTime> weekdaysCampusToCity;
  List<DateTime> weekdaysCityToCampus;
  List<DateTime> weekendCityToCampus;

  factory BusTiming.fromJson(Map<String, dynamic> json) => BusTiming(
        weekendCampusToCity:
            List<dynamic>.from(json["weekend_campusToCity"].map((x) => x)),
        id: json["_id"],
        busStop: json[" busStop"],
        weekdaysCampusToCity: List<DateTime>.from(
            json["weekdays_campusToCity"].map((x) => DateTime.parse(x))),
        weekdaysCityToCampus: List<DateTime>.from(
            json["weekdays_cityToCampus"].map((x) => DateTime.parse(x))),
        weekendCityToCampus: List<DateTime>.from(
            json["weekend_cityToCampus"].map((x) => DateTime.parse(x))),
      );

  Map<String, dynamic> toJson() => {
        "weekend_campusToCity":
            List<dynamic>.from(weekendCampusToCity.map((x) => x)),
        "_id": id,
        " busStop": busStop,
        "weekdays_campusToCity": List<dynamic>.from(
            weekdaysCampusToCity.map((x) => x.toIso8601String())),
        "weekdays_cityToCampus": List<dynamic>.from(
            weekdaysCityToCampus.map((x) => x.toIso8601String())),
        "weekend_cityToCampus": List<dynamic>.from(
            weekendCityToCampus.map((x) => x.toIso8601String())),
      };
}
