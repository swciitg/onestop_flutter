import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_dev/models/medicalcontacts/dropdown_contact_model.dart';

part 'medicalcontact_model.g.dart';

@JsonSerializable()
class MedicalcontactModel {
  late DropdownContactModel name;
  @JsonKey(defaultValue: "Untitled")
  late String category;
  @JsonKey(defaultValue: "Unknown")
  late String email;
  @JsonKey(defaultValue: "123456789")
  late String phone;
  @JsonKey(defaultValue: "")
  late String? designation;
  @JsonKey(defaultValue: "")
  late String? degree;


//Constructor
  MedicalcontactModel(
      {required this.name, required this.email, required this.phone, required this.category,  this.designation,  this.degree});
  factory MedicalcontactModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalcontactModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalcontactModelToJson(this);
}
