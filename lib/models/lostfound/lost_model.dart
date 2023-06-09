import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lost_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LostModel {
  final String title;
  final String location;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final String phonenumber;
  final String email;
  final DateTime date;
  @JsonKey(name: '_id')
  final String id;

  const LostModel(
      {Key? key,
      required this.title,
      required this.description,
      required this.location,
      required this.imageURL,
      required this.email,
      required this.compressedImageURL,
      required this.date,
      required this.id,
      required this.phonenumber});

  factory LostModel.fromJson(Map<String, dynamic> json) =>
      _$LostModelFromJson(json);

  Map<String, dynamic> toJson() => _$LostModelToJson(this);
}
