// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel(
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'],
    );

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'userId': instance.userId,
    };
