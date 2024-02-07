import 'package:json_annotation/json_annotation.dart';

part 'quick_link.g.dart';

@JsonSerializable()
class QuickLinkModel {
  @JsonKey(defaultValue: "Name")
  late String name;
  @JsonKey(defaultValue: 1234)
  late int icon;
  @JsonKey(defaultValue: "https://swc.iitg.ac.in/swc")
  late String url;

//Constructor
  QuickLinkModel(
      {required this.name, required this.icon, required this.url});
  factory QuickLinkModel.fromJson(Map<String, dynamic> json) =>
      _$QuickLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuickLinkModelToJson(this);
}
