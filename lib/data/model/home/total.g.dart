// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Total _$TotalFromJson(Map<String, dynamic> json) => Total(
  locations: (json['locations'] as num?)?.toInt(),
  connectors: (json['connectors'] as num?)?.toInt(),
  available: (json['available'] as num?)?.toInt(),
);

Map<String, dynamic> _$TotalToJson(Total instance) => <String, dynamic>{
  'locations': instance.locations,
  'connectors': instance.connectors,
  'available': instance.available,
};
