import 'package:json_annotation/json_annotation.dart';

part 'mess_menu_model.g.dart';
@JsonSerializable()
class MessMenu {
  final String id;
  final String hostel;
  final Day monday;
  final Day tuesday;
  final Day wednesday;
  final Day thursday;
  final Day friday;
  final Day saturday;
  final Day sunday;
  final int v;

  MessMenu({
    required this.id,
    required this.hostel,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.v,
  });
  factory MessMenu.fromJson(Map<String, dynamic> json) => _$MessMenuFromJson(json);

  Map<String, dynamic> toJson() => _$MessMenuToJson(this);

}
@JsonSerializable()
class Day {
  final String id;
  final MealType breakfast;
  final MealType lunch;
  final MealType dinner;

  Day({
    required this.id,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}
@JsonSerializable()
class MealType {
  final String id;
  final String mealDescription;
  final String timing;

  MealType({
    required this.id,
    required this.mealDescription,
    required this.timing,
  });
  factory MealType.fromJson(Map<String, dynamic> json) => _$MealTypeFromJson(json);

  Map<String, dynamic> toJson() => _$MealTypeToJson(this);

}
// @JsonSerializable()
// class MessMenuModel {
//   @JsonKey(defaultValue: "Untitled Hostel")
//   late String hostel;
//
//   @JsonKey(defaultValue: "Untitled Meal")
//   late String meal;
//
//   @JsonKey(defaultValue: "Untitled Menu")
//   late String menu;
//
//   @JsonKey(defaultValue: "Untitled Timing")
//   late String timing;
//
//   @JsonKey(defaultValue: "Untitled Day")
//   late String day;
//
//   MessMenuModel(
//       {required this.hostel,
//       required this.meal,
//       required this.menu,
//       required this.day,
//       required this.timing});
//
//   factory MessMenuModel.fromJson(Map<String, dynamic> json) =>
//       _$MessMenuModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$MessMenuModelToJson(this);
//}
