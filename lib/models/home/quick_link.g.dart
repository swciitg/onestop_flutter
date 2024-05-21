// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickLinkModel _$QuickLinkModelFromJson(Map<String, dynamic> json) =>
    QuickLinkModel(
      name: json['name'] as String? ?? 'Name',
      icon: (json['icon'] as num?)?.toInt() ?? 1234,
      url: json['url'] as String? ?? 'https://swc.iitg.ac.in/swc',
    );

Map<String, dynamic> _$QuickLinkModelToJson(QuickLinkModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'url': instance.url,
    };
