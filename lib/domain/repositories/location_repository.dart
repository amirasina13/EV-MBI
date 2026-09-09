abstract class LocationRepository {
  Future<dynamic> getLocationDetails(
    String uuid,
    String latitude,
    String longitude,
  );
}
