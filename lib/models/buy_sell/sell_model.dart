import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sell_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SellModel {
  final String title;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final String phonenumber;
  final String price;
  final DateTime date;
  final String username;
  final String email;
  @JsonKey(name: '_id')
  final String id;

  const SellModel(
      {Key? key,
        required this.title,
        required this.description,
        required this.imageURL,
        required this.compressedImageURL,
        required this.date,
        required this.phonenumber,
        required this.price,
        required this.email,
        required this.id,
        required this.username});

  factory SellModel.fromJson(Map<String, dynamic> json) =>
      _$SellModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellModelToJson(this);
}
