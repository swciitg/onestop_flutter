// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'ferry_data_model.g.dart';

@JsonSerializable()
class FerryTimeData {
  final String name;
  final List<String> MonToFri_GuwahatiToNorthGuwahati;
  final List<String> MonToFri_NorthGuwahatiToGuwahati;
  final List<String> Sunday_GuwahatiToNorthGuwahati;
  final List<String> Sunday_NorthGuwahatiToGuwahati;


  FerryTimeData(this.name, this.MonToFri_GuwahatiToNorthGuwahati, this.MonToFri_NorthGuwahatiToGuwahati, this.Sunday_GuwahatiToNorthGuwahati, this.Sunday_NorthGuwahatiToGuwahati);

  factory FerryTimeData.fromJson(Map<String, dynamic> json) => _$FerryTimeDataFromJson(json);

  Map<String, dynamic> toJson() => _$FerryTimeDataToJson(this);
}