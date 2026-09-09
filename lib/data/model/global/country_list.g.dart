// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryList _$CountryListFromJson(Map<String, dynamic> json) => CountryList(
  name: json['name'] as String?,
  code: json['code'] as String?,
  callCode: json['callCode'] as String?,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$CountryListToJson(CountryList instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'callCode': instance.callCode,
      'timezone': instance.timezone,
    };
