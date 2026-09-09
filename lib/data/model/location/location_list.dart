import 'package:json_annotation/json_annotation.dart';

part 'location_list.g.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR LOCATION LIST
*/

@JsonSerializable()
class LocationList {
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
  final String? status;
  final String? distance;
  final String? imagePath;

  const LocationList({
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
    this.status,
    this.distance,
    this.imagePath,
  });

  factory LocationList.fromJson(Map<String, dynamic> json) =>
      _$LocationListFromJson(json);

  Map<String, dynamic> toJson() => _$LocationListToJson(this);
}
