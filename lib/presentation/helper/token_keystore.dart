import '../../config/config.dart';

class TokenKeystore {
  /// write to keystore/keychain
  Future<void> saveToken(String token) async {
    await Storage().secureStorage.write(key: 'token', value: token);
  }

  /// read to keystore/keychain
  Future<String> getToken() async {
    return await Storage().secureStorage.read(key: 'token') ?? '';
  }

  /// delete from keystore/keychain
  Future<void> deleteToken() async {
    await Storage().secureStorage.delete(key: 'token');
  }
}
