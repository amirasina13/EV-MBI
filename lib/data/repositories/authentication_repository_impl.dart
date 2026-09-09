// Repository for auth
import '../../domain/domain.dart';
import '../data.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final RemoteAuthenticationApi remoteAuthenticationApi;

  AuthenticationRepositoryImpl({required this.remoteAuthenticationApi});

  @override
  Future<dynamic> verifyRegister({required String email}) async {
    return remoteAuthenticationApi.verifyRegister(email: email);
  }

  @override
  Future<dynamic> register({
    required String email,
    required String password,
    required String vToken,
  }) async {
    return remoteAuthenticationApi.register(
      email: email,
      password: password,
      vToken: vToken,
    );
  }

  @override
  Future<Map> forgotPassword({required String email}) async {
    return remoteAuthenticationApi.forgotPassword(email: email);
  }

  @override
  Future<dynamic> verifyPasswordOtp({
    required String token,
    required String password,
    required String otpCode,
  }) async {
    return remoteAuthenticationApi.verifyPasswordOtp(
      token: token,
      password: password,
      otpCode: otpCode,
    );
  }

  @override
  Future<Map> generateOtp({
    required String email,
    required String sendVia,
    required String purpose,
    required String vToken,
  }) async {
    return remoteAuthenticationApi.generateOtp(
      email: email,
      sendVia: sendVia,
      purpose: purpose,
      vToken: vToken,
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<dynamic> verifyOtp({
    required String token,
    required String otpCode,
  }) async {
    return remoteAuthenticationApi.verifyOtp(token: token, otpCode: otpCode);
  }
}
