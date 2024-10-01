import 'package:json_annotation/json_annotation.dart';

part 'dropdown_contact_model.g.dart';

@JsonSerializable()
class DropdownContactModel {
  @JsonKey(defaultValue: "Untitled")
  late String? name;
  @JsonKey(defaultValue: "Untitled")
  late String? degree;
  @JsonKey(defaultValue: "Untitled")
  late String? designation;
  


//Constructor
  DropdownContactModel(
      { this.name,  this.degree,  this.designation});
  factory DropdownContactModel.fromJson(Map<String, dynamic> json) =>
      _$DropdownContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$DropdownContactModelToJson(this);
}
