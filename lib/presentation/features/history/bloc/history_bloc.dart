import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../../../locator.dart';
import '../history.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryListGetUseCase _historyListGetUseCase;
  final HistoryDetailGetUseCase _historyDetailGetUseCase;

  int page = 0;
  bool isFetching = false, isFirstShow = true, isRefresh = false;

  HistoryBloc()
    : _historyListGetUseCase = sl(),
      _historyDetailGetUseCase = sl(),
      super(HistoryInitial()) {
    on<HistoryListLoad>((event, emit) async {
      await _mapHistoryListLoadEventToState(event, emit);
    });
    on<HistoryDetailsLoad>((event, emit) async {
      await _mapHistoryDetailLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get list outlet based on brands
  Future<void> _mapHistoryListLoadEventToState(
    HistoryListLoad event,
    Emitter<HistoryState> emit,
  ) async {
    if (isFetching == false) {
      emit(HistoryLoading());
    } else {
      emit(HistoryNextLoading());
    }

    // First, get token in storage
    var token = await _getToken();
    var internet = await checkInternet();

    if (!internet) {
      emit(HistoryNetworkError('No internet Connection.'));
      return;
    }

    try {
      if (isFirstShow == true) {
        page = 0;
      }

      if (token != '') {
        var historyListGetResults = await _historyListGetUseCase.execute(
          HistoryListGetParams(token: token, page: page),
        );

        var locationList = historyListGetResults.history;

        if (locationList.records == null || locationList.records!.isEmpty) {
          if (page == 0) {
            emit(HistoryEmpty());
          } else {
            emit(HistoryListStop());
          }
        } else {
          final startIndex = locationList.next!.indexOf('=');
          final endIndex = locationList.next!.indexOf(
            '&',
            startIndex + '='.length,
          );

          page = int.parse(
            locationList.next!.substring(startIndex + '='.length, endIndex),
          );

          emit(HistoryLoaded(history: locationList));
        }
      } else {
        emit(HistoryTokenEmpty());
      }
    } catch (e) {
      if (e is MaintenanceException) {
        emit(HistoryMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(HistorySessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(HistoryError(e.message));
      } else {
        emit(HistoryError(e.toString()));
      }
    }
  }

  // Function to get list outlet based on brands
  Future<void> _mapHistoryDetailLoadEventToState(
    event,
    Emitter<HistoryState> emit,
  ) async {
    if (!isRefresh) {
      emit(HistoryDetailsLoading());
    } else {
      emit(HistoryDetailsRefresh());
    }

    // check internet connection first
    var internet = await checkInternet();

    if (!internet) {
      emit(HistoryNetworkError('No internet Connection.'));
      return;
    }

    try {
      // call get history details API in historyDetailsGetUseCase
      var historyDetailsGetResults = await _historyDetailGetUseCase.execute(
        HistoryDetailGetParams(token: Storage().token, id: event.id),
      );

      // declare the details
      var details = historyDetailsGetResults.details;

      // if details is null or no value, state will be historyDetailsEmpty
      if (details == null) {
        emit(HistoryDetailsEmpty());
        // else state will be historyDetailsLoaded
      } else {
        emit(HistoryDetailsLoaded(historyDetails: details));
      }
    } catch (e) {
      if (e is MaintenanceException) {
        emit(HistoryMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(HistorySessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(HistoryError(e.message));
      } else {
        emit(HistoryError(e.toString()));
      }
    }
  }

  /// read to keystore/keychain
  Future<String> _getToken() async {
    return await Storage().secureStorage.read(key: 'token') ?? '';
  }
}
