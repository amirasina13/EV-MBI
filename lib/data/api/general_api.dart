import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../data.dart';

class GeneralApi {
  // Generate OTP API
  Future<dynamic> generateOtp({
    required String email,
    required String sendVia,
    required String purpose,
    required String vToken,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.generateOtp);
    var data = json.encode(<String, String?>{
      'send_to': email,
      'send_via': sendVia,
      'purpose': purpose,
      'vToken': vToken,
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

      if (jsonResponse['status'] != true) {
        throw InvalidStatusException(message: jsonResponse['message']);
      }

      return jsonResponse;
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP API
  Future<dynamic> verifyOtp({
    required String token,
    required String otpCode,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.verifyOtp);
    var data = json.encode(<String, String?>{'token': token, 'otp': otpCode});

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

      if (jsonResponse['status'] != true) {
        throw InvalidStatusException(message: jsonResponse['message']);
      }

      return jsonResponse;
    } catch (e) {
      rethrow;
    }
  }
}
