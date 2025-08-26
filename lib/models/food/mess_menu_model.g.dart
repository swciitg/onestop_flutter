// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mess_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessMenu _$MessMenuFromJson(Map<String, dynamic> json) => MessMenu(
  id: json['id'] as String,
  hostel: json['hostel'] as String,
  monday: Day.fromJson(json['monday'] as Map<String, dynamic>),
  tuesday: Day.fromJson(json['tuesday'] as Map<String, dynamic>),
  wednesday: Day.fromJson(json['wednesday'] as Map<String, dynamic>),
  thursday: Day.fromJson(json['thursday'] as Map<String, dynamic>),
  friday: Day.fromJson(json['friday'] as Map<String, dynamic>),
  saturday: Day.fromJson(json['saturday'] as Map<String, dynamic>),
  sunday: Day.fromJson(json['sunday'] as Map<String, dynamic>),
  v: (json['v'] as num).toInt(),
);

Map<String, dynamic> _$MessMenuToJson(MessMenu instance) => <String, dynamic>{
  'id': instance.id,
  'hostel': instance.hostel,
  'monday': instance.monday,
  'tuesday': instance.tuesday,
  'wednesday': instance.wednesday,
  'thursday': instance.thursday,
  'friday': instance.friday,
  'saturday': instance.saturday,
  'sunday': instance.sunday,
  'v': instance.v,
};

Day _$DayFromJson(Map<String, dynamic> json) => Day(
  id: json['id'] as String,
  breakfast: MealType.fromJson(json['breakfast'] as Map<String, dynamic>),
  lunch: MealType.fromJson(json['lunch'] as Map<String, dynamic>),
  dinner: MealType.fromJson(json['dinner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
  'id': instance.id,
  'breakfast': instance.breakfast,
  'lunch': instance.lunch,
  'dinner': instance.dinner,
};

MealType _$MealTypeFromJson(Map<String, dynamic> json) => MealType(
  id: json['id'] as String,
  mealDescription: json['mealDescription'] as String,
  startTiming: DateTime.parse(json['startTiming'] as String),
  endTiming: DateTime.parse(json['endTiming'] as String),
);

Map<String, dynamic> _$MealTypeToJson(MealType instance) => <String, dynamic>{
  'id': instance.id,
  'mealDescription': instance.mealDescription,
  'startTiming': instance.startTiming.toIso8601String(),
  'endTiming': instance.endTiming.toIso8601String(),
};
