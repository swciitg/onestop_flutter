import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EventModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final DateTime date;
  final String club_org;
  final String venue;
  final String contactNumber;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.compressedImageURL,
    required this.date,
    required this.club_org,
    required this.venue,
    required this.contactNumber,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
