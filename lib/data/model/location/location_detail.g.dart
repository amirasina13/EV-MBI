// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDetail _$LocationDetailFromJson(Map<String, dynamic> json) =>
    LocationDetail(
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
      juiceUpId: json['juiceUpId'] as String?,
      status: json['status'] as String?,
      distance: json['distance'] as String?,
      fullAddress: json['full_address'] as String?,
      imagePath: json['imagePath'] as String?,
      connectors: (json['connectors'] as List<dynamic>?)
          ?.map((e) => ConnectorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationDetailToJson(LocationDetail instance) =>
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
      'juiceUpId': instance.juiceUpId,
      'status': instance.status,
      'distance': instance.distance,
      'full_address': instance.fullAddress,
      'imagePath': instance.imagePath,
      'connectors': instance.connectors,
    };
