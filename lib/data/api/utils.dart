import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/config.dart';

enum RequestType { post, get, put, delete }

class HttpClient {
  Future<Map<String, String>> createHeader({required RequestType type}) async {
    final language = await _generateLanguage();

    switch (type) {
      case RequestType.post:
        {
          var header = <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': language,
          }..addAll(_getBasicAuthHeader());

          return header;
        }
      case RequestType.get:
        return _getBasicAuthHeader();
      case RequestType.put:
        return _getBasicAuthHeader();
      case RequestType.delete:
        return _getBasicAuthHeader();
    }
  }

  Map<String, String> _getBasicAuthHeader() {
    return <String, String>{
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$apiUsername:${_generatePassword()}'))}',
    };
  }

  Uri createUri(String route, [Map<String, dynamic> param = const {}]) {
    var baseUri = Uri.parse(apiUrl + route);

    // Only add query parameters if the map is not empty
    if (param.isNotEmpty) {
      var urlWithParams = baseUri.replace(queryParameters: param);
      return urlWithParams;
    }

    return baseUri;
  }

  String _generatePassword() {
    return apiPassword;
  }

  Future<String> _generateLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var getLang = prefs.getString('lang') ?? 'en';

    String language = getLang == 'en' ? 'english' : 'malay';

    return language;
  }
}
