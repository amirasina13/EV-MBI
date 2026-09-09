import 'package:json_annotation/json_annotation.dart';

import 'history_list.dart';

part 'history.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR HISTORY
*/

@JsonSerializable()
class History {
  final List<HistoryList>? records;
  final String? next;

  const History({this.records, this.next});

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
