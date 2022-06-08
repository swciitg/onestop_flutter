// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      name: json['name'] as String? ?? 'Untitled',
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((e) =>
                  ContactDetailsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      group: json['group'] as String? ?? '',
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'contacts': instance.contacts.map((e) => e.toJson()).toList(),
      'group': instance.group,
    };
