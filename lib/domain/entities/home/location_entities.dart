import '../../domain.dart';
import '../entity.dart';

// location entity

class LocationHomeEntity extends Entity<int> {
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
  final String? juiceUpId;
  final String? status;
  final String? distance;
  final String? fullAddress;
  final String? imagePath;
  final ConnectorEntity? connectors;

  const LocationHomeEntity({
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
    this.juiceUpId,
    this.status,
    this.distance,
    this.fullAddress,
    this.imagePath,
    this.connectors,
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
    juiceUpId,
    status,
    distance,
    fullAddress,
    imagePath,
    connectors,
  ];
}
