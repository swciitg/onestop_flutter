import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_kit/onestop_kit.dart';

part 'buy_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BuyModel {
  final String title;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final String phonenumber;
  final String price;
  final DateTime date;
  final String username;
  final String email;
  final OneStopUser? user;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(defaultValue: false)
  final bool isNew;

  const BuyModel({
    Key? key,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.compressedImageURL,
    required this.date,
    required this.phonenumber,
    required this.price,
    required this.email,
    required this.id,
    required this.username,
    required this.isNew,
    required this.user,
  });

  factory BuyModel.fromJson(Map<String, dynamic> json) => _$BuyModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyModelToJson(this);
}
