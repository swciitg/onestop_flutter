import 'package:json_annotation/json_annotation.dart';

part 'ferry_data_model.g.dart';

@JsonSerializable()
class FerryTimeData {
  final String Name;
  final List<String> MonToFri_GuwahatiToNorthGuwahati;
  final List<String> MonToFri_NorthGuwahatiToGuwahati;
  final List<String> Sunday_GuwahatiToNorthGuwahati;
  final List<String> Sunday_NorthGuwahatiToGuwahati;


  FerryTimeData(this.Name, this.MonToFri_GuwahatiToNorthGuwahati, this.MonToFri_NorthGuwahatiToGuwahati, this.Sunday_GuwahatiToNorthGuwahati, this.Sunday_NorthGuwahatiToGuwahati);

  factory FerryTimeData.fromJson(Map<String, dynamic> json) => _$FerryTimeDataFromJson(json);

  Map<String, dynamic> toJson() => _$FerryTimeDataToJson(this);
}