// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      name: json['name'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      category: json['category'] as String? ?? '',
      date: json['date'] as String? ?? '',
      starttime1: json['starttime1'] as String? ?? '',
      endtime1: json['endtime1'] as String? ?? '',
      starttime2: json['starttime2'] as String? ?? '',
      endtime2: json['endtime2'] as String? ?? '',
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'degree': instance.degree,
      'designation': instance.designation,
      'category': instance.category,
      'date': instance.date,
      'starttime1': instance.starttime1,
      'endtime1': instance.endtime1,
      'starttime2': instance.starttime2,
      'endtime2': instance.endtime2,
    };
