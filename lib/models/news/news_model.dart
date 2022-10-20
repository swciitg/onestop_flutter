import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'news_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewsModel {
  final String title;
  final String body;
  final String author;


  NewsModel(
      {Key? key,
        required this.title,
        required this.body,
        required this.author,
     });
  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsModelToJson(this);
}
