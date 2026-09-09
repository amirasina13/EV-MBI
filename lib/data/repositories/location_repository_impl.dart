import '../../domain/domain.dart';
import '../data.dart';

// Repository for location

class LocationRepositoryImpl extends LocationRepository {
  final RemoteLocationApi remoteLocationApi;

  LocationRepositoryImpl({required this.remoteLocationApi});

  @override
  Future<dynamic> getLocationDetails(
    String uuid,
    String latitude,
    String longitude,
  ) async {
    return remoteLocationApi.getLocationDetails(uuid, latitude, longitude);
  }
}
