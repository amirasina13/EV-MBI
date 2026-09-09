import '../../../locator.dart';
import '../../domain.dart';

// History list useCase

abstract class HistoryListGetUseCase
    implements BaseUseCase<HistoryListGetResult, HistoryListGetParams> {}

class HistoryListGetUseCaseImpl extends HistoryListGetUseCase {
  @override
  Future<HistoryListGetResult> execute(HistoryListGetParams params) async {
    try {
      // Get list history
      HistoryRepository historyRepository = sl();
      var historyList = await historyRepository.getHistoryList(
        params.token,
        params.page,
      );

      // If got data, pass to historyListListGetResult
      // ignore: unnecessary_null_comparison
      if (historyList != null) {
        return HistoryListGetResult(history: historyList, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to historyListGetException
    return HistoryListGetResult(
      history: null,
      result: false,
      exception: HistoryListGetException(
        exception: Exception('No Transaction Found'),
      ),
    );
  }
}

// HistoryListGetResult is trigger when result != null
class HistoryListGetResult extends UseCaseResult {
  dynamic history;

  HistoryListGetResult({required this.history, super.exception, super.result});
}

// HistoryListGetParams class is defined and wrapped around the parameters
class HistoryListGetParams {
  String token;
  int page;
  HistoryListGetParams({required this.token, required this.page});
}

// Trigger Exception
class HistoryListGetException implements Exception {
  Exception exception;

  HistoryListGetException({required this.exception});
}
