// Location detail useCase

import '../../../locator.dart';
import '../../domain.dart';

abstract class LocationDetailGetUseCase
    implements BaseUseCase<LocationDetailGetResult, LocationDetailGetParams> {}

class LocationDetailGetUseCaseImpl extends LocationDetailGetUseCase {
  @override
  Future<LocationDetailGetResult> execute(
    LocationDetailGetParams params,
  ) async {
    try {
      // Get list locationDetail
      LocationRepository locationRepository = sl();
      var locationDetail = await locationRepository.getLocationDetails(
        params.uuid,
        params.latitude,
        params.longitude,
      );

      // If got data, pass to locationDetailGetResult
      // ignore: unnecessary_null_comparison
      if (locationDetail != null) {
        return LocationDetailGetResult(details: locationDetail, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to LocationDetailGetException
    return LocationDetailGetResult(
      details: null,
      result: false,
      exception: LocationDetailGetException(
        exception: Exception('No Location Found'),
      ),
    );
  }
}

// LocationDetailGetResult is trigger when result != null
class LocationDetailGetResult extends UseCaseResult {
  dynamic details;

  LocationDetailGetResult({
    required this.details,
    super.exception,
    super.result,
  });
}

// LocationDetailGetParams class is defined and wrapped around the parameters
class LocationDetailGetParams {
  String uuid;
  String latitude;
  String longitude;

  LocationDetailGetParams({
    required this.uuid,
    required this.latitude,
    required this.longitude,
  });
}

// Trigger Exception
class LocationDetailGetException implements Exception {
  Exception exception;

  LocationDetailGetException({required this.exception});
}
