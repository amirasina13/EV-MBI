// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: (json['id'] as num?)?.toInt(),
  image: json['image'] as String?,
  code: json['code'] as String?,
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  forename: json['forename'] as String?,
  dob: json['dob'] as String?,
  gender: json['gender'] as String?,
  contact: json['contact'] as String?,
  cCode: json['cCode'] as String?,
  cValid: json['cValid'] as bool?,
  email: json['email'] as String?,
  eValid: json['eValid'] as bool?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'code': instance.code,
      'name': instance.name,
      'surname': instance.surname,
      'forename': instance.forename,
      'dob': instance.dob,
      'gender': instance.gender,
      'contact': instance.contact,
      'cCode': instance.cCode,
      'cValid': instance.cValid,
      'email': instance.email,
      'eValid': instance.eValid,
    };
