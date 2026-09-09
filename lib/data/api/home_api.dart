import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../data.dart';

class RemoteHomeApi extends HomeRepository {
  @override
  Future<dynamic> getHomePage(String latitude, String longitude) async {
    var param = <String, dynamic>{'latitude': latitude, 'longitude': longitude};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.getHomepage, param);

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

      return Homepage.fromJson(jsonResponse['data']);
    } catch (e) {
      rethrow;
    }
  }
}
