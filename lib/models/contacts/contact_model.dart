import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';

part 'contact_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactModel {
  @JsonKey(defaultValue: "Untitled")
  late String sectionName;
  @JsonKey(defaultValue: [])
  late List<ContactDetailsModel> contacts;

  //Constructor
  ContactModel(
      {required this.sectionName, required this.contacts});

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
  //This constructor also does the work of initialising the variables
  // ContactModel.fromJson(Map<String, dynamic> json) {
  //   sectionName = json['sectionName'];
  //   parent = 'Campus';
  //   contacts = [];
  //   List<dynamic>.from(json['contacts']).forEach((element) {
  //     contacts.add(ContactDetailsModel.fromJson(element));
  //   });
  // }
}
