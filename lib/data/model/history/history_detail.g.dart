// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryDetail _$HistoryDetailFromJson(Map<String, dynamic> json) =>
    HistoryDetail(
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
      referenceId: json['referenceId'] as String?,
      startCharge: json['startCharge'] as String?,
      endCharge: json['endCharge'] as String?,
      duration: json['duration'] as String?,
      salesAmount: json['salesAmount'] as String?,
      currency: json['currency'] as String?,
      powerDraw: json['powerDraw'] as String?,
      soc: json['soc'] as String?,
      paymentGateway: json['paymentGateway'] as String?,
      paymentId: json['paymentId'] as String?,
      status: json['status'] as String?,
      energy: json['energy'] as String?,
      durationLabel: json['duration_label'] as String?,
      energyLabel: json['energy_label'] as String?,
      rateLabel: json['rate_label'] as String?,
      rate: json['rate'] as String?,
    );

Map<String, dynamic> _$HistoryDetailToJson(HistoryDetail instance) =>
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
      'referenceId': instance.referenceId,
      'startCharge': instance.startCharge,
      'endCharge': instance.endCharge,
      'duration': instance.duration,
      'salesAmount': instance.salesAmount,
      'currency': instance.currency,
      'powerDraw': instance.powerDraw,
      'soc': instance.soc,
      'paymentGateway': instance.paymentGateway,
      'paymentId': instance.paymentId,
      'status': instance.status,
      'energy': instance.energy,
      'duration_label': instance.durationLabel,
      'energy_label': instance.energyLabel,
      'rate_label': instance.rateLabel,
      'rate': instance.rate,
    };
