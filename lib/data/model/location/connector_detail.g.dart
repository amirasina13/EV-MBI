// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectorDetail _$ConnectorDetailFromJson(Map<String, dynamic> json) =>
    ConnectorDetail(
      uuid: json['uuid'] as String?,
      chargePointIdentity: json['chargePointIdentity'] as String?,
      chargerType: json['chargerType'] as String?,
      connectorId: json['connectorId'] as String?,
      connectorLabel: json['connectorLabel'] as String?,
      connectorType: json['connectorType'] as String?,
      ratedPower: json['ratedPower'] as String?,
      perKWh: json['perKWh'] as String?,
      perMin: json['perMin'] as String?,
      chargeUnit: json['chargeUnit'] as String?,
      status: convertToString(json['status']),
      rate: json['rate'] as String?,
    );

Map<String, dynamic> _$ConnectorDetailToJson(ConnectorDetail instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'chargePointIdentity': instance.chargePointIdentity,
      'chargerType': instance.chargerType,
      'connectorId': instance.connectorId,
      'connectorLabel': instance.connectorLabel,
      'connectorType': instance.connectorType,
      'ratedPower': instance.ratedPower,
      'perKWh': instance.perKWh,
      'perMin': instance.perMin,
      'chargeUnit': instance.chargeUnit,
      'status': instance.status,
      'rate': instance.rate,
    };
