import 'package:json_annotation/json_annotation.dart';

part 'history_detail.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR TRANSACTION HISTORY DETAIL
*/

@JsonSerializable()
class HistoryDetail {
  final String? id;
  final String? terminalTranId;
  final String? connectorId;
  final String? chargerType;
  final String? connectorType;
  final String? connectorLabel;
  final String? ratedPower;
  final String? chargePointIdentity;
  final String? locationUUID;
  final String? locationName;
  final String? referenceId;
  final String? startCharge;
  final String? endCharge;
  final String? duration;
  final String? salesAmount;
  final String? currency;
  final String? powerDraw;
  final String? soc;
  final String? paymentGateway;
  final String? paymentId;
  final String? status;
  final String? energy;
  @JsonKey(name: 'duration_label')
  final String? durationLabel;
  @JsonKey(name: 'energy_label')
  final String? energyLabel;
  @JsonKey(name: 'rate_label')
  final String? rateLabel;
  final String? rate;

  const HistoryDetail({
    this.id,
    this.terminalTranId,
    this.connectorId,
    this.chargerType,
    this.connectorType,
    this.connectorLabel,
    this.ratedPower,
    this.chargePointIdentity,
    this.locationUUID,
    this.locationName,
    this.referenceId,
    this.startCharge,
    this.endCharge,
    this.duration,
    this.salesAmount,
    this.currency,
    this.powerDraw,
    this.soc,
    this.paymentGateway,
    this.paymentId,
    this.status,
    this.energy,
    this.durationLabel,
    this.energyLabel,
    this.rateLabel,
    this.rate,
  });

  factory HistoryDetail.fromJson(Map<String, dynamic> json) =>
      _$HistoryDetailFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDetailToJson(this);
}
