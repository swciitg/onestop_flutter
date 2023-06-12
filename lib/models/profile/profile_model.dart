import 'package:json_annotation/json_annotation.dart';
part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String name;
  final String rollNo;
  final String outlookEmail;
  final String? altEmail;
  final String? phoneNumber;
  final String? emergencyPhoneNumber;
  final String? gender;
  final String? roomNo;
  final String? homeAddress;
  final String? dob;
  final String? hostel;
  final String? linkedin;
  final String? image;
  ProfileModel(
      {required this.name,
      required this.rollNo,
      required this.outlookEmail,
      this.altEmail,
      this.phoneNumber,
      this.emergencyPhoneNumber,
        this.gender,
        this.roomNo,
        this.homeAddress,
        this.dob,
      this.hostel,
      this.linkedin,
      this.image});

  factory ProfileModel.fromJson(Map<String, dynamic> map) =>
      _$ProfileModelFromJson(map);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
