// Repository for global

import '../../domain/domain.dart';
import '../data.dart';

class GlobalRepositoryImpl extends GlobalRepository {
  final RemoteGlobalApi remoteGlobalApi;

  GlobalRepositoryImpl({required this.remoteGlobalApi});

  @override
  Future<List<CountryList>> getCountries() async {
    return remoteGlobalApi.getCountries();
  }
}
