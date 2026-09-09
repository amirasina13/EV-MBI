import '../entity.dart';

// history list entity

class HistoryListEntity extends Entity<int> {
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
  final String? durationLabel;
  final String? energyLabel;

  const HistoryListEntity({
    required int id,
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
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    terminalTranId,
    connectorId,
    chargerType,
    connectorType,
    connectorLabel,
    ratedPower,
    chargePointIdentity,
    locationUUID,
    locationName,
    startCharge,
    endCharge,
    duration,
    salesAmount,
    status,
    created,
    energy,
    durationLabel,
    energyLabel,
  ];
}
