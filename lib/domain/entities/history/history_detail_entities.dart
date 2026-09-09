import '../entity.dart';

// history detail entity

class HistoryDetailEntity extends Entity<int> {
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
  final String? oriSalesAmount;
  final String? salesAmount;
  final String? currency;
  final String? powerDraw;
  final String? soc;
  final String? paymentGateway;
  final String? paymentId;
  final String? status;
  final String? energy;
  final String? durationLabel;
  final String? energyLabel;

  const HistoryDetailEntity({
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
    this.referenceId,
    this.startCharge,
    this.endCharge,
    this.duration,
    this.oriSalesAmount,
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
    referenceId,
    startCharge,
    endCharge,
    duration,
    oriSalesAmount,
    salesAmount,
    currency,
    powerDraw,
    soc,
    paymentGateway,
    paymentId,
    status,
    energy,
    durationLabel,
    energyLabel,
  ];
}
