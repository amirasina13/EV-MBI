import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final Storage _instance = Storage._internal();

  factory Storage() => _instance;

  Storage._internal();

  // STORAGE
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String token = '';
  String? latitude = '3.1390';
  String? longitude = '101.6869';
  String? locPermission = '';
  String lastUpdateCheck = '';
  String lastUpdateLoc = '';
  String otpToken = '';
  String? referralCode = '';
  String? fromPage = '';
  String? reasonDelete = '';
}
