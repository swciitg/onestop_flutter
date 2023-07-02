// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      sectionName: json['sectionName'] as String? ?? 'Untitled',
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((e) =>
                  ContactDetailsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'sectionName': instance.sectionName,
      'contacts': instance.contacts.map((e) => e.toJson()).toList(),
    };
