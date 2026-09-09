// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connector _$ConnectorFromJson(Map<String, dynamic> json) => Connector(
  unavailable: (json['unavailable'] as num?)?.toInt(),
  available: (json['available'] as num?)?.toInt(),
  inuse: (json['inuse'] as num?)?.toInt(),
);

Map<String, dynamic> _$ConnectorToJson(Connector instance) => <String, dynamic>{
  'unavailable': instance.unavailable,
  'available': instance.available,
  'inuse': instance.inuse,
};
