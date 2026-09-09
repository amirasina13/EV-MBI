import '../entity.dart';

// Connector detail entity

class ConnectorDetailEntity extends Entity<int> {
  final String? uuid;
  final String? chargePointIdentity;
  final String? chargerType;
  final String? connectorId;
  final String? connectorLabel;
  final String? connectorType;
  final String? ratedPower;
  final String? perKWh;
  final String? perMin;
  final String? chargeUnit;
  final String? status;
  final String? rate;

  const ConnectorDetailEntity({
    required int id,
    this.uuid,
    this.chargePointIdentity,
    this.chargerType,
    this.connectorId,
    this.connectorLabel,
    this.connectorType,
    this.ratedPower,
    this.perKWh,
    this.perMin,
    this.chargeUnit,
    this.status,
    this.rate,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    uuid,
    chargePointIdentity,
    chargerType,
    connectorId,
    connectorLabel,
    connectorType,
    ratedPower,
    perKWh,
    perMin,
    chargeUnit,
    status,
    rate,
  ];
}
