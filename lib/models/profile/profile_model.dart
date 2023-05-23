import 'package:json_annotation/json_annotation.dart';
part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String username;
  final String rollNumber;
  final String outlook;
  final String gmail;
  final String contact;
  final String emergencyContact;
  final String hostel;
  final String? linkedin;
  final DateTime? date;
  ProfileModel({
    required this.username,
    required this.rollNumber,
    required this.outlook,
    required this.gmail,
    required this.contact,
    required this.emergencyContact,
    required this.hostel,
    this.linkedin,
    this.date,
  });

  factory ProfileModel.fromJson(Map<String,dynamic> map) => _$ProfileModelFromJson(map);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
