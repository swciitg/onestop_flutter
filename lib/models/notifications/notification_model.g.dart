// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifsModel _$NotifsModelFromJson(Map<String, dynamic> json) => NotifsModel(
  title: json['title'] as String?,
  body: json['body'] as String?,
  read: json['read'] as bool?,
  category: json['category'] as String,
  time:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  messageId: json['_id'] as String,
);

Map<String, dynamic> _$NotifsModelToJson(NotifsModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'category': instance.category,
      'read': instance.read,
      'createdAt': instance.time?.toIso8601String(),
      '_id': instance.messageId,
    };
