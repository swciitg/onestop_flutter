import 'dart:convert';

BusTiming busTimingFromJson(String str) => BusTiming.fromJson(json.decode(str));

String busTimingToJson(BusTiming data) => json.encode(data.toJson());

class BusTiming {
  BusTiming({
    required this.busTiming,
    required this.weekdaysCampusToCity,
    required this.weekdaysCityToCampus,
    required this.weekendCityToCampus,
    required this.weekendCampusToCity,
  });

  String busTiming;
  DateTime weekdaysCampusToCity;
  DateTime weekdaysCityToCampus;
  DateTime weekendCityToCampus;
  DateTime weekendCampusToCity;

  factory BusTiming.fromJson(Map<dynamic, dynamic> json) => BusTiming(
        busTiming: json["busTiming"],
        weekdaysCampusToCity: json["weekdays_campusToCity"],
        weekdaysCityToCampus: json["weekdays_cityToCampus"],
        weekendCityToCampus: json["weekend_cityToCampus"],
        weekendCampusToCity: json["weekend_campusToCity"],
      );

  Map<dynamic, dynamic> toJson() => {
        "busTiming": busTiming,
        "weekdays_campusToCity": weekdaysCampusToCity,
        "weekdays_cityToCampus": weekdaysCityToCampus,
        "weekend_cityToCampus": weekendCityToCampus,
        "weekend_campusToCity": weekendCampusToCity,
      };
}
