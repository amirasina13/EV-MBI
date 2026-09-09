import 'package:json_annotation/json_annotation.dart';

part 'history_list.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR LOCATION LIST
*/

@JsonSerializable()
class HistoryList {
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
  final String? startCharge;
  final String? endCharge;
  final String? duration;
  final String? salesAmount;
  final String? status;
  final String? created;
  final String? energy;
  @JsonKey(name: 'duration_label')
  final String? durationLabel;
  @JsonKey(name: 'energy_label')
  final String? energyLabel;

  const HistoryList({
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
    this.startCharge,
    this.endCharge,
    this.duration,
    this.salesAmount,
    this.status,
    this.created,
    this.energy,
    this.durationLabel,
    this.energyLabel,
  });

  factory HistoryList.fromJson(Map<String, dynamic> json) =>
      _$HistoryListFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryListToJson(this);
}
