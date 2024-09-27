import 'package:json_annotation/json_annotation.dart';

part 'medicalcontact_model.g.dart';

@JsonSerializable()
class MedicalcontactModel {
  @JsonKey(defaultValue: "Untitled")
  late String name;
  @JsonKey(defaultValue: "Untitled")
  late String category;
  @JsonKey(defaultValue: "Unknown")
  late String email;
  @JsonKey(defaultValue: "123456789")
  late String contact;
  @JsonKey(defaultValue: "Untitled")
  late String designation;
  @JsonKey(defaultValue: "Untitled")
  late String degree;


//Constructor
  MedicalcontactModel(
      {required this.name, required this.email, required this.contact, required this.category, required this.designation, required this.degree});
  factory MedicalcontactModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalcontactModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalcontactModelToJson(this);
}
