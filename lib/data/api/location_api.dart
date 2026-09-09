import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../data.dart';

class RemoteLocationApi extends LocationRepository {
  @override
  // Get outlet details
  Future<dynamic> getLocationDetails(
    String uuid,
    String latitude,
    String longitude,
  ) async {
    var header = HttpClient().createHeader(type: RequestType.get);
    var param = <String, dynamic>{
      'uuid': uuid,
      'latitude': latitude,
      'longitude': longitude,
    };

    var route = HttpClient().createUri(ServerAddresses.locationDetail, param);

    try {
      var response = await http.get(route, headers: await header);

      if (response.statusCode != 200) {
        throw HttpRequestException();
      }

      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['isMaintenance'] == true) {
        throw MaintenanceException(
          isMaintenance: jsonResponse['isMaintenance'],
          message: jsonResponse['message'],
        );
      }

      if (jsonResponse['status'] != true) {
        throw InvalidStatusException(message: jsonResponse['message']);
      }

      var details = LocationDetail.fromJson(jsonResponse['data']);

      return details;
    } catch (e) {
      rethrow;
    }
  }
}
