// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mess_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessMenuModel _$MessMenuModelFromJson(Map<String, dynamic> json) =>
    MessMenuModel(
      hostel: json['hostel'] as String? ?? 'Untitled Hostel',
      meal: json['meal'] as String? ?? 'Untitled Meal',
      menu: json['menu'] as String? ?? 'Untitled Menu',
      day: json['day'] as String? ?? 'Untitled Day',
      timing: json['timing'] as String? ?? 'Untitled Timing',
    );

Map<String, dynamic> _$MessMenuModelToJson(MessMenuModel instance) =>
    <String, dynamic>{
      'hostel': instance.hostel,
      'meal': instance.meal,
      'menu': instance.menu,
      'timing': instance.timing,
      'day': instance.day,
    };
