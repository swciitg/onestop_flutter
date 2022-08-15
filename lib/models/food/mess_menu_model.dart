import 'package:json_annotation/json_annotation.dart';

part 'mess_menu_model.g.dart';

@JsonSerializable()
class MessMenuModel {
  @JsonKey(defaultValue: "Untitled Hostel")
  late String hostel;

  @JsonKey(defaultValue: "Untitled Meal")
  late String meal;

  @JsonKey(defaultValue: "Untitled Menu")
  late String menu;

  @JsonKey(defaultValue: "Untitled Timing")
  late String timing;

  @JsonKey(defaultValue: "Untitled Day")
  late String day;

  MessMenuModel(
      {required this.hostel,
      required this.meal,
      required this.menu,
      required this.day,
      required this.timing});

  factory MessMenuModel.fromJson(Map<String, dynamic> json) =>
      _$MessMenuModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessMenuModelToJson(this);
}

