// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationList _$LocationListFromJson(Map<String, dynamic> json) => LocationList(
  id: json['id'] as String?,
  uuid: json['uuid'] as String?,
  image: json['image'] as String?,
  place: json['place'] as String?,
  address: json['address'] as String?,
  addressTwo: json['address_two'] as String?,
  city: json['city'] as String?,
  postCode: json['postCode'] as String?,
  state: json['state'] as String?,
  countryCode: json['countryCode'] as String?,
  country: json['country'] as String?,
  placeId: json['placeId'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  status: json['status'] as String?,
  distance: json['distance'] as String?,
  imagePath: json['imagePath'] as String?,
);

Map<String, dynamic> _$LocationListToJson(LocationList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'image': instance.image,
      'place': instance.place,
      'address': instance.address,
      'address_two': instance.addressTwo,
      'city': instance.city,
      'postCode': instance.postCode,
      'state': instance.state,
      'countryCode': instance.countryCode,
      'country': instance.country,
      'placeId': instance.placeId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'distance': instance.distance,
      'imagePath': instance.imagePath,
    };
