import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'found_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FoundModel{

  final String title;
  final String location;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final DateTime date;
  final String submittedat;

  const FoundModel({Key? key, required this.title, required this.description,required this.location,required this.imageURL,required this.compressedImageURL,required this.date,required this.submittedat});
  factory FoundModel.fromJson(Map<String, dynamic> json) => _$FoundModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoundModelToJson(this);
}
