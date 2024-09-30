import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  @JsonKey(defaultValue: "")
  late String? name;
  @JsonKey(defaultValue: "")
  late String? degree;
  @JsonKey(defaultValue: "")
  late String? designation;
  @JsonKey(defaultValue: "")
  late String? category;
  @JsonKey(defaultValue: "")
  late String? date;
  @JsonKey(defaultValue: "")
  late String? starttime1;
  @JsonKey(defaultValue: "")
  late String? endtime1;
  @JsonKey(defaultValue: "")
  late String? starttime2;
  @JsonKey(defaultValue: "")
  late String? endtime2;

  DoctorModel.clone(DoctorModel c)
      : this(
          name: c.name,
          degree: c.degree,
          designation: c.designation,
          category: c.category,
          date: c.date,
          starttime1: c.starttime1,
          endtime1: c.endtime1,
          starttime2: c.starttime2,
          endtime2: c.endtime2 
        );
  
  


//Constructor
  DoctorModel(
      {this.name, this.degree,this.designation,this.category,this.date,this.starttime1,this.endtime1,this.starttime2,this.endtime2});
  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
