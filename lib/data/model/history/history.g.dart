// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
  records: (json['records'] as List<dynamic>?)
      ?.map((e) => HistoryList.fromJson(e as Map<String, dynamic>))
      .toList(),
  next: json['next'] as String?,
);

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
  'records': instance.records,
  'next': instance.next,
};
