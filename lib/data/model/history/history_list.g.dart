// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryList _$HistoryListFromJson(Map<String, dynamic> json) => HistoryList(
  id: json['id'] as String?,
  terminalTranId: json['terminalTranId'] as String?,
  connectorId: json['connectorId'] as String?,
  chargerType: json['chargerType'] as String?,
  connectorType: json['connectorType'] as String?,
  connectorLabel: json['connectorLabel'] as String?,
  ratedPower: json['ratedPower'] as String?,
  chargePointIdentity: json['chargePointIdentity'] as String?,
  locationUUID: json['locationUUID'] as String?,
  locationName: json['locationName'] as String?,
  startCharge: json['startCharge'] as String?,
  endCharge: json['endCharge'] as String?,
  duration: json['duration'] as String?,
  salesAmount: json['salesAmount'] as String?,
  status: json['status'] as String?,
  created: json['created'] as String?,
  energy: json['energy'] as String?,
  durationLabel: json['duration_label'] as String?,
  energyLabel: json['energy_label'] as String?,
);

Map<String, dynamic> _$HistoryListToJson(HistoryList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'terminalTranId': instance.terminalTranId,
      'connectorId': instance.connectorId,
      'chargerType': instance.chargerType,
      'connectorType': instance.connectorType,
      'connectorLabel': instance.connectorLabel,
      'ratedPower': instance.ratedPower,
      'chargePointIdentity': instance.chargePointIdentity,
      'locationUUID': instance.locationUUID,
      'locationName': instance.locationName,
      'startCharge': instance.startCharge,
      'endCharge': instance.endCharge,
      'duration': instance.duration,
      'salesAmount': instance.salesAmount,
      'status': instance.status,
      'created': instance.created,
      'energy': instance.energy,
      'duration_label': instance.durationLabel,
      'energy_label': instance.energyLabel,
    };
