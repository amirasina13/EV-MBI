// History detail useCase

import '../../../locator.dart';
import '../../domain.dart';

abstract class HistoryDetailGetUseCase
    implements BaseUseCase<HistoryDetailGetResult, HistoryDetailGetParams> {}

class HistoryDetailGetUseCaseImpl extends HistoryDetailGetUseCase {
  @override
  Future<HistoryDetailGetResult> execute(HistoryDetailGetParams params) async {
    try {
      // Get   HistoryDetail
      HistoryRepository historyRepository = sl();
      var historyDetail = await historyRepository.getHistoryDetails(
        params.token,
        params.id,
      );

      // If got data, pass to HistoryDetailGetResult
      // ignore: unnecessary_null_comparison
      if (historyDetail != null) {
        return HistoryDetailGetResult(details: historyDetail, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to HistoryDetailGetException
    return HistoryDetailGetResult(
      details: null,
      result: false,
      exception: HistoryDetailGetException(
        exception: Exception('No Location Found'),
      ),
    );
  }
}

// HistoryDetailGetResult is trigger when result != null
class HistoryDetailGetResult extends UseCaseResult {
  dynamic details;

  HistoryDetailGetResult({
    required this.details,
    super.exception,
    super.result,
  });
}

// HistoryDetailGetParams class is defined and wrapped around the parameters
class HistoryDetailGetParams {
  String token;
  String id;

  HistoryDetailGetParams({required this.token, required this.id});
}

// Trigger Exception
class HistoryDetailGetException implements Exception {
  Exception exception;

  HistoryDetailGetException({required this.exception});
}
