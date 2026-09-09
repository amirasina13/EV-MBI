import '../domain.dart';

abstract class UserRepository {
  Future<Map> login({required UserEntity user});

  Future<Map> verifyToken({required String token});

  Future<dynamic> getUserProfile({required String token});

  Future<dynamic> updateProfile({
    required String token,
    required String name,
    required String surname,
    required String forename,
    required String contact,
  });

  Future<dynamic> updateProfilePhoto({
    required String token,
    required String image,
  });

  Future<dynamic> deleteAcc({
    required String token,
    required String reason,
    required String email,
  });
}
