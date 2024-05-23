import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_image.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeImageModel {
  final String imageUrl;
  final String redirectUrl;

  HomeImageModel({
    Key? key,
    required this.imageUrl,
    required this.redirectUrl,
  });

  factory HomeImageModel.fromJson(Map<String, dynamic> json) =>
      _$HomeImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeImageModelToJson(this);
}
