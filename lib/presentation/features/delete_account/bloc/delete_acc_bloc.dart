import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../delete_acc.dart';

class DeleteAccBloc extends Bloc<DeleteAccEvent, DeleteAccState> {
  final UserRepository userRepository;

  DeleteAccBloc({required this.userRepository}) : super(DeleteAccInitial()) {
    on<DeleteAccReason>((event, emit) async {
      await _mapDeleteAccReasonEventToState(event.reason, emit);
    });
    on<DeleteAccSend>((event, emit) async {
      await _mapDeleteAccSendEventToState(event.email, emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get reason to delete account
  Future<void> _mapDeleteAccReasonEventToState(
    String reason,
    Emitter<DeleteAccState> emit,
  ) async {
    emit(DeleteAccProcessing());

    var internet = await checkInternet();

    if (!internet) {
      emit(VerifyNetworkError('No internet Connection.'));
      return;
    }

    try {
      Storage().reasonDelete = reason;

      emit(AccReasonDeleted());
    } catch (e) {
      if (e is MaintenanceException) {
        emit(DeleteAccMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(DeleteAccSessionError(message: e.message));
      } else if (e is InvalidStatusException) {
        emit(DeleteAccError(e.message));
      } else {
        emit(DeleteAccError(e.toString()));
      }
    }
  }

  // Function send to delete account API
  Future<void> _mapDeleteAccSendEventToState(
    String email,
    Emitter<DeleteAccState> emit,
  ) async {
    emit(DeleteAccProcessing());

    var internet = await checkInternet();

    if (!internet) {
      emit(VerifyNetworkError('No internet Connection.'));
      return;
    }

    try {
      var token = Storage().token;
      var reason = Storage().reasonDelete;

      var accDeleted = await userRepository.deleteAcc(
        token: token,
        reason: reason!,
        email: email,
      );

      if (accDeleted['status']) {
        Storage().token = '';
        Storage().reasonDelete = '';

        emit(DeleteAccSent(accDeleted['message']));
      } else {
        emit(DeleteAccError(accDeleted['message']));
      }
    } catch (e) {
      if (e is MaintenanceException) {
        emit(DeleteAccMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(DeleteAccSessionError(message: e.message));
      } else if (e is InvalidStatusException) {
        emit(DeleteAccError(e.message));
      } else {
        emit(DeleteAccError(e.toString()));
      }
    }
  }
}
