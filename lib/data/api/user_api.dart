import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../../presentation/helper/helper.dart';
import '../data.dart';

class RemoteUserApi extends UserRepository {
  @override
  // Login API
  Future<Map> login({required UserEntity user}) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.login);
    var data = json.encode(user.toMap());

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
  // Login token verify
  Future<Map> verifyToken({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.verify, param);

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

      return jsonResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  // Get user profile
  Future<dynamic> getUserProfile({required String token}) async {
    var param = <String, dynamic>{'token': token, 'access': 'mobile'};
    var header = HttpClient().createHeader(type: RequestType.get);
    var route = HttpClient().createUri(ServerAddresses.profile, param);

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

      return UserProfile.fromJson(jsonResponse['data']['profile']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  // Update profile data (setting)
  Future<dynamic> updateProfile({
    required String token,
    required String name,
    required String surname,
    required String forename,
    required String contact,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.profileUpdate);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'surname': surname,
      'forename': forename,
      'name': name,
      'contact': contact,
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
  // Update profile photo
  Future<dynamic> updateProfilePhoto({
    required String token,
    required String image,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.profilePhoto);
    var data = json.encode(<String, String?>{
      'token': token,
      'access': 'mobile',
      'image': 'data:image/jpeg;base64,$image',
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

  // Delete account
  @override
  Future<dynamic> deleteAcc({
    required String token,
    required String reason,
    required String email,
  }) async {
    var header = HttpClient().createHeader(type: RequestType.post);
    var route = HttpClient().createUri(ServerAddresses.deleteAccount);
    var data = json.encode(<String, String?>{
      'email': email,
      'reason': reason,
      'token': token,
      'access': 'mobile',
    });

    try {
      var response = await http.post(route, headers: await header, body: data);
      Map jsonResponse = json.decode(response.body);

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
}
