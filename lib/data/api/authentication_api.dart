import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../data.dart';

class RemoteAuthenticationApi extends AuthenticationRepository {
  @override
  // Verify Register API
  Future<dynamic> verifyRegister({required String email}) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.verifyRegister);
    var data = json.encode(<String, String?>{'email': email});

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

  @override
  // Register user API
  Future<dynamic> register({
    required String email,
    required String password,
    required String vToken,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.register);
    var data = json.encode(<String, String?>{
      'email': email,
      'password': password,
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

  @override
  // Forgot password API
  Future<Map> forgotPassword({required String email}) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.forgot);
    var data = json.encode(<String, String?>{'email': email});

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

  @override
  // Reset password API
  Future<dynamic> verifyPasswordOtp({
    required String token,
    required String password,
    required String otpCode,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.reset);
    var data = json.encode(<String, String?>{
      'token': token,
      'password': password,
      'otp': otpCode,
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

  // Generate OTP API
  @override
  Future<Map> generateOtp({
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
  @override
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
