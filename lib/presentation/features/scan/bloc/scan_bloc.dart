import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../../helper/helper.dart';
import '../scan.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final HistoryRepository historyRepository;

  bool reloadBack = false;

  ScanBloc({required this.historyRepository}) : super(ScanInitial()) {
    on<ScanLoad>((event, emit) async {
      await _mapScanLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get Scan info/ user details
  Future<void> _mapScanLoadEventToState(
    ScanLoad event,
    Emitter<ScanState> emit,
  ) async {
    var token = await _getToken();

    var internet = await checkInternet();

    if (!internet) {
      emit(ScanNetworkError(error: 'No internet Connection.'));
      return;
    }

    try {
      var scanResult = await historyRepository.scanCode(token, event.scanCode);

      emit(ScanSuccess(scanResult: scanResult));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(ScanMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        TokenKeystore().deleteToken();
        emit(ScanSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(ScanError(error: e.message));
      } else {
        emit(ScanError(error: e.toString()));
      }
    }
  }

  /// read to keystore/keychain
  Future<String> _getToken() async {
    return await Storage().secureStorage.read(key: 'token') ?? '';
  }
}
