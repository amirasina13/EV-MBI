abstract class AuthenticationRepository {
  Future<dynamic> verifyRegister({required String email});

  Future<dynamic> register({
    required String email,
    required String password,
    required String vToken,
  });

  Future<Map> forgotPassword({required String email});

  Future<dynamic> verifyPasswordOtp({
    required String token,
    required String password,
    required String otpCode,
  });

  Future<Map> generateOtp({
    required String email,
    required String sendVia,
    required String purpose,
    required String vToken,
  });

  Future<dynamic> verifyOtp({required String token, required String otpCode});
}
