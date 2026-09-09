import 'package:json_annotation/json_annotation.dart';

part 'total.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR Total
*/

@JsonSerializable()
class Total {
  final int? locations;
  final int? connectors;
  final int? available;

  const Total({this.locations, this.connectors, this.available});

  factory Total.fromJson(Map<String, dynamic> json) => _$TotalFromJson(json);

  Map<String, dynamic> toJson() => _$TotalToJson(this);
}
