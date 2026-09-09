// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homepage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Homepage _$HomepageFromJson(Map<String, dynamic> json) => Homepage(
  total: json['total'] == null
      ? null
      : Total.fromJson(json['total'] as Map<String, dynamic>),
  locations: (json['locations'] as List<dynamic>?)
      ?.map((e) => LocationHome.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HomepageToJson(Homepage instance) => <String, dynamic>{
  'total': instance.total,
  'locations': instance.locations,
};
