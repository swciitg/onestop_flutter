import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';

part 'all_doctors.g.dart';

@JsonSerializable()
class AllDoctors {
  @JsonKey(defaultValue: [])
  late List<DoctorModel>? alldoctors;

  AllDoctors({ this.alldoctors});

  void addDocToList(DoctorModel c) => alldoctors?.add(c);
  
  factory AllDoctors.fromJson(Map<String, dynamic> json) =>
      _$AllDoctorsFromJson(json);

  Map<String, dynamic> toJson() => _$AllDoctorsToJson(this);
}
