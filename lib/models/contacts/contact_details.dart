import 'package:json_annotation/json_annotation.dart';
part 'contact_details.g.dart';

@JsonSerializable()
class ContactDetailsModel {
  @JsonKey(defaultValue: "Untitled")
  late String name;
  @JsonKey(defaultValue: "Unknown")
  late String email;
  @JsonKey(defaultValue: "123456789")
  late String contact;

//Constructor
  ContactDetailsModel(
      {required this.name, required this.email, required this.contact});
  factory ContactDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ContactDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDetailsModelToJson(this);

//This constructor also does the work of initialising the variables
// ContactDetailsModel.fromJson(Map<String, dynamic> json) {
// name = json['name'];
// contact = json['contact'];
// email = json['email'];
// }

// Map<String,dynamic> toJson() {return {};}
}
