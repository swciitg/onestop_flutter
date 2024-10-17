import 'dart:convert';

class EventModel {
  String id;
  String title;
  String imageUrl;
  String compressedImageUrl;
  String description;
  String clubOrg;
  String board;
  DateTime startDateTime;
  DateTime endDateTime;
  String venue;
  List<String> categories;
  int v;

  EventModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.compressedImageUrl,
    required this.description,
    required this.clubOrg,
    required this.board,
    required this.startDateTime,
    required this.endDateTime,
    required this.venue,
    required this.categories,
    required this.v,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? compressedImageUrl,
    String? description,
    String? clubOrg,
    String? board,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? venue,
    List<String>? categories,
    int? v,
  }) =>
      EventModel(
        id: id ?? this.id,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        compressedImageUrl: compressedImageUrl ?? this.compressedImageUrl,
        description: description ?? this.description,
        clubOrg: clubOrg ?? this.clubOrg,
        board: board ?? this.board,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        venue: venue ?? this.venue,
        categories: categories ?? this.categories,
        v: v ?? this.v,
      );

  factory EventModel.fromRawJson(String str) => EventModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json["_id"],
    title: json["title"],
    imageUrl: json["imageURL"],
    compressedImageUrl: json["compressedImageURL"],
    description: json["description"],
    clubOrg: json["club_org"],
    board: json["board"],
    startDateTime: DateTime.parse(json["startDateTime"]),
    endDateTime: DateTime.parse(json["endDateTime"]),
    venue: json["venue"],
    categories: List<String>.from(json["categories"].map((x) => x)),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "imageURL": imageUrl,
    "compressedImageURL": compressedImageUrl,
    "description": description,
    "club_org": clubOrg,
    "board": board,
    "startDateTime": startDateTime.toIso8601String(),
    "endDateTime": endDateTime.toIso8601String(),
    "venue": venue,
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "__v": v,
  };
}


/*
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EventModel {
  //@JsonKey(name: '_id')
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
*/
