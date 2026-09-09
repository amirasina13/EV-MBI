import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR LOCATION DETAIL
*/

@JsonSerializable()
class UserProfile {
  final int? id;
  final String? image;
  final String? code;
  final String? name;
  final String? surname;
  final String? forename;
  final String? dob;
  final String? gender;
  final String? contact;
  final String? cCode;
  final bool? cValid;
  final String? email;
  final bool? eValid;

  const UserProfile({
    this.id,
    this.image,
    this.code,
    this.name,
    this.surname,
    this.forename,
    this.dob,
    this.gender,
    this.contact,
    this.cCode,
    this.cValid,
    this.email,
    this.eValid,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
