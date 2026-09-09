abstract class HistoryRepository {
  Future<dynamic> scanCode(String token, String scanCode);

  Future<dynamic> getHistoryList(String token, int page);

  Future<dynamic> getHistoryDetails(String token, String id);
}
