// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allmedicalcontacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Allmedicalcontacts _$AllmedicalcontactsFromJson(Map<String, dynamic> json) =>
    Allmedicalcontacts(
      alldoctors: (json['alldoctors'] as List<dynamic>?)
              ?.map((e) =>
                  MedicalcontactModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AllmedicalcontactsToJson(Allmedicalcontacts instance) =>
    <String, dynamic>{
      'alldoctors': instance.alldoctors,
    };
