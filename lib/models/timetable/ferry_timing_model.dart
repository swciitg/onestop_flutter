import 'dart:convert';

FerryTiming ferryTimingFromJson(String str) =>
    FerryTiming.fromJson(json.decode(str));

String ferryTimingToJson(FerryTiming data) => json.encode(data.toJson());

class FerryTiming {
  FerryTiming({
    required this.ferryGhat,
    required this.weekdaysCampusToCity,
    required this.weekdaysCityToCampus,
    required this.weekendCityToCampus,
    required this.weekendCampusToCity,
  });

  String ferryGhat;
  DateTime weekdaysCampusToCity;
  DateTime weekdaysCityToCampus;
  DateTime weekendCityToCampus;
  DateTime weekendCampusToCity;

  factory FerryTiming.fromJson(Map<dynamic, dynamic> json) => FerryTiming(
        ferryGhat: json["ferryGhat"],
        weekdaysCampusToCity: json["weekdays_campusToCity"],
        weekdaysCityToCampus: json["weekdays_cityToCampus"],
        weekendCityToCampus: json["weekend_cityToCampus"],
        weekendCampusToCity: json["weekend_campusToCity"],
      );

  Map<dynamic, dynamic> toJson() => {
        "ferryGhat": ferryGhat,
        "weekdays_campusToCity": weekdaysCampusToCity,
        "weekdays_cityToCampus": weekdaysCityToCampus,
        "weekend_cityToCampus": weekendCityToCampus,
        "weekend_campusToCity": weekendCampusToCity,
      };
}
