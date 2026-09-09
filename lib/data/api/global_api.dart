import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../data.dart';

class RemoteGlobalApi extends GlobalRepository {
  // Get Countries list
  @override
  Future<List<CountryList>> getCountries() async {
    var route = HttpClient().createUri(ServerAddresses.country);
    var header = HttpClient().createHeader(type: RequestType.get);

    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult.contains(ConnectivityResult.none)) {
      throw InvalidNetworkException(message: 'No internet Connection.');
    }

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

      List<dynamic> data = jsonResponse['data'];
      List<CountryList> countries = [];
      for (int i = 0; i < data.length; i++) {
        countries.add(CountryList.fromJson(data[i]));
      }

      return countries;
    } catch (e) {
      rethrow;
    }
  }
}
