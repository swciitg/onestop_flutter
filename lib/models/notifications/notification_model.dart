import 'package:json_annotation/json_annotation.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class NotifsModel {
  String? title;
  String? body;
  String category = "Lost";
  bool? read = false;

  @JsonKey(name: "createdAt")
  DateTime? time = DateTime.now();

  @JsonKey(name: "_id")
  String messageId = "";
  NotifsModel(
      {
        this.title,
      this.body,
        this.read,
      required this.category,
      required this.time,
      required this.messageId
});

  factory NotifsModel.fromJson(Map<String, dynamic> map) =>
      _$NotifsModelFromJson(map);

  Map<String, dynamic> toJson() => _$NotifsModelToJson(this);
}
