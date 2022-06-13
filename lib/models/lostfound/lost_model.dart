import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lost_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LostModel{
  final String title;
  final String location;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final String phonenumber;
  final DateTime date;

  const LostModel({Key? key, required this.title, required this.description,required this.location,required this.imageURL,required this.compressedImageURL,required this.date,required this.phonenumber});

  factory LostModel.fromJson(Map<String, dynamic> json) => _$LostModelFromJson(json);

  Map<String, dynamic> toJson() => _$LostModelToJson(this);
}
