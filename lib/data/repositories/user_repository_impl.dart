import '../../domain/domain.dart';
import '../data.dart';

// Repository for user
class UserRepositoryImpl extends UserRepository {
  final RemoteUserApi remoteUserApi;

  UserRepositoryImpl({required this.remoteUserApi});

  @override
  Future<Map> login({required UserEntity user}) async {
    return remoteUserApi.login(user: user);
  }

  @override
  Future<Map> verifyToken({required String token}) async {
    return remoteUserApi.verifyToken(token: token);
  }

  @override
  Future<dynamic> getUserProfile({required String token}) async {
    try {
      return remoteUserApi.getUserProfile(token: token);
    } catch (error) {
      rethrow;
    }
  }

  // Repository for profile update (setting)
  @override
  Future<dynamic> updateProfile({
    required String token,
    required String name,
    required String surname,
    required String forename,
    required String contact,
  }) async {
    return remoteUserApi.updateProfile(
      token: token,
      name: name,
      surname: surname,
      forename: forename,
      contact: contact,
    );
  }

  @override
  Future<dynamic> updateProfilePhoto({
    required String token,
    required String image,
  }) async {
    return remoteUserApi.updateProfilePhoto(token: token, image: image);
  }

  @override
  Future<dynamic> deleteAcc({
    required String token,
    required String reason,
    required String email,
  }) async {
    return remoteUserApi.deleteAcc(token: token, reason: reason, email: email);
  }
}
