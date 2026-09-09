import '../../domain/domain.dart';
import '../data.dart';

// Repository for transaction history

class HistoryRepositoryImpl extends HistoryRepository {
  final RemoteHistoryApi remoteHistoryApi;

  HistoryRepositoryImpl({required this.remoteHistoryApi});

  @override
  Future<dynamic> scanCode(String token, String scanCode) async {
    return remoteHistoryApi.scanCode(token, scanCode);
  }

  @override
  Future<dynamic> getHistoryList(String token, int page) async {
    return remoteHistoryApi.getHistoryList(token, page);
  }

  @override
  Future<dynamic> getHistoryDetails(String token, String id) async {
    return remoteHistoryApi.getHistoryDetails(token, id);
  }
}
