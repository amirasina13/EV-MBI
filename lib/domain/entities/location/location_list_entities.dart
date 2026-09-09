import '../entity.dart';

// Location list entity

class LocationListEntity extends Entity<int> {
  final String? uuid;
  final String? image;
  final String? place;
  final String? address;
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

  const LocationListEntity({
    required int id,
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
    // this.external,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    uuid,
    image,
    place,
    address,
    addressTwo,
    city,
    postCode,
    state,
    countryCode,
    country,
    placeId,
    latitude,
    longitude,
    status,
    distance,
    imagePath,
  ];
}
