import 'package:json_annotation/json_annotation.dart';

part 'country_list.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR COUNTRY LIST
*/

@JsonSerializable()
class CountryList {
  final String? name;
  final String? code;
  final String? callCode;
  final String? timezone;

  const CountryList({this.name, this.code, this.callCode, this.timezone});

  factory CountryList.fromJson(Map<String, dynamic> json) =>
      _$CountryListFromJson(json);

  Map<String, dynamic> toJson() => _$CountryListToJson(this);
}
