import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../../presentation/helper/helper.dart';
import '../data.dart';

class RemoteHistoryApi extends HistoryRepository {
  // Scan QR API
  @override
  Future<dynamic> scanCode(String token, String scanCode) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.scanCode);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'code': scanCode,
    });

    try {
      var response = await http.post(route, headers: await header, body: data);

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

      if (jsonResponse['session'] != true) {
        TokenKeystore().deleteToken();
        throw InvalidSessionException(message: jsonResponse['message']);
      }

      if (jsonResponse['status'] != true) {
        throw InvalidStatusException(message: jsonResponse['message']);
      }

      return jsonResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  // Get history list
  Future<dynamic> getHistoryList(String token, int offset) async {
    var header = HttpClient().createHeader(type: RequestType.get);
    var param = <String, dynamic>{
      'offset': offset.toString(),
      'token': token,
      'access': 'mobile',
    };
    var route = HttpClient().createUri(ServerAddresses.transactionList, param);

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

      if (jsonResponse['session'] != true) {
        TokenKeystore().deleteToken();
        throw InvalidSessionException(message: jsonResponse['message']);
      }

      if (jsonResponse['status'] != true) {
        throw InvalidStatusException(message: jsonResponse['message']);
      }

      return History.fromJson(jsonResponse['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  // Get history details
  Future<dynamic> getHistoryDetails(String token, String id) async {
    var header = HttpClient().createHeader(type: RequestType.get);
    var param = <String, dynamic>{'token': token, 'access': 'mobile', 'id': id};
    var route = HttpClient().createUri(
      ServerAddresses.transactionDetail,
      param,
    );

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

      if (jsonResponse['session'] != true) {
        TokenKeystore().deleteToken();
        throw InvalidSessionException(message: jsonResponse['message']);
      }

      if (jsonResponse['status'] != true) {
        throw InvalidStatusException(message: jsonResponse['message']);
      }

      var details = HistoryDetail.fromJson(jsonResponse['data']['transaction']);

      return details;
    } catch (e) {
      rethrow;
    }
  }
}
