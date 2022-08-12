import 'package:json_annotation/json_annotation.dart';

part 'ferry_data_model.g.dart';

@JsonSerializable()
class FerryTimeData {
  /// The generated code assumes these values exist in JSON.
  final String Name;
  final List<String> MonToFri_GuwahatiToNorthGuwahati;
  final List<String> MonToFri_NorthGuwahatiToGuwahati;
  final List<String> Sunday_GuwahatiToNorthGuwahati;
  final List<String> Sunday_NorthGuwahatiToGuwahati;
  /// The generated code below handles if the corresponding JSON value doesn't
  /// exist or is empty.


  FerryTimeData(this.Name, this.MonToFri_GuwahatiToNorthGuwahati, this.MonToFri_NorthGuwahatiToGuwahati, this.Sunday_GuwahatiToNorthGuwahati, this.Sunday_NorthGuwahatiToGuwahati);

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory FerryTimeData.fromJson(Map<String, dynamic> json) => _$FerryTimeDataFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$FerryTimeDataToJson(this);
}