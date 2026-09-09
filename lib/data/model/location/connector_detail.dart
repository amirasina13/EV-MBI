import 'package:json_annotation/json_annotation.dart';

import '../../../presentation/helper/helper.dart';

part 'connector_detail.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR CONNECTOR DETAIL
*/

@JsonSerializable()
class ConnectorDetail {
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
  @JsonKey(fromJson: convertToString)
  final String? status;
  final String? rate;

  const ConnectorDetail({
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
  });

  factory ConnectorDetail.fromJson(Map<String, dynamic> json) =>
      _$ConnectorDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectorDetailToJson(this);
}
