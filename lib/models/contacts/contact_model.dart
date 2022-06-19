import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
part 'contact_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactModel {
  @JsonKey(defaultValue: "Untitled")
  late String name;
  @JsonKey(defaultValue: [])
  late List<ContactDetailsModel> contacts;
  @JsonKey(defaultValue: "")
  late String group;

  //Constructor
  ContactModel(
      {required this.name, required this.contacts, required this.group});

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
  //This constructor also does the work of initialising the variables
  // ContactModel.fromJson(Map<String, dynamic> json) {
  //   name = json['name'];
  //   parent = 'Campus';
  //   contacts = [];
  //   List<dynamic>.from(json['contacts']).forEach((element) {
  //     contacts.add(ContactDetailsModel.fromJson(element));
  //   });
  // }
}
