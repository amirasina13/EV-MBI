import 'package:json_annotation/json_annotation.dart';

import '../../data.dart';

part 'homepage.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR Homepage
*/

@JsonSerializable()
class Homepage {
  final Total? total;
  final List<LocationHome>? locations;

  const Homepage({this.total, this.locations});

  factory Homepage.fromJson(Map<String, dynamic> json) =>
      _$HomepageFromJson(json);

  Map<String, dynamic> toJson() => _$HomepageToJson(this);
}
