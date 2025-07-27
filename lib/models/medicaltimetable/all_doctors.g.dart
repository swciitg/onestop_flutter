// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_doctors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllDoctors _$AllDoctorsFromJson(Map<String, dynamic> json) => AllDoctors(
  alldoctors:
      (json['alldoctors'] as List<dynamic>?)
          ?.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$AllDoctorsToJson(AllDoctors instance) =>
    <String, dynamic>{'alldoctors': instance.alldoctors};
