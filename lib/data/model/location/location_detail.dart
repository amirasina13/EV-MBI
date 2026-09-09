import 'package:json_annotation/json_annotation.dart';

import '../../data.dart';

part 'location_detail.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR LOCATION DETAIL
*/

@JsonSerializable()
class LocationDetail {
  final String? id;
  final String? uuid;
  final String? image;
  final String? place;
  final String? address;
  @JsonKey(name: 'address_two')
  final String? addressTwo;
  final String? city;
  final String? postCode;
  final String? state;
  final String? countryCode;
  final String? country;
  final String? placeId;
  final String? latitude;
  final String? longitude;
  final String? juiceUpId;
  final String? status;
  final String? distance;
  @JsonKey(name: 'full_address')
  final String? fullAddress;
  final String? imagePath;
  final List<ConnectorDetail>? connectors;

  const LocationDetail({
    this.id,
    this.uuid,
    this.image,
    this.place,
    this.address,
    this.addressTwo,
    this.city,
    this.postCode,
    this.state,
    this.countryCode,
    this.country,
    this.placeId,
    this.latitude,
    this.longitude,
    this.juiceUpId,
    this.status,
    this.distance,
    this.fullAddress,
    this.imagePath,
    this.connectors,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) =>
      _$LocationDetailFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDetailToJson(this);
}
