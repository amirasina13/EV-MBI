import '../../domain/domain.dart';
import '../data.dart';

// Repository for home

class HomeRepositoryImpl extends HomeRepository {
  final RemoteHomeApi remoteHomeApi;

  HomeRepositoryImpl({required this.remoteHomeApi});

  @override
  Future<dynamic> getHomePage(String latitude, String longitude) async {
    return remoteHomeApi.getHomePage(latitude, longitude);
  }
}
