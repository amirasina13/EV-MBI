import 'package:json_annotation/json_annotation.dart';

part 'connector.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR Connector
*/

@JsonSerializable()
class Connector {
  final int? unavailable;
  final int? available;
  final int? inuse;

  const Connector({this.unavailable, this.available, this.inuse});

  factory Connector.fromJson(Map<String, dynamic> json) =>
      _$ConnectorFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectorToJson(this);
}
