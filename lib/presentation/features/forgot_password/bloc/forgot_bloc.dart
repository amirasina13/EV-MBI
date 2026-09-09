import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../forgot_password.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  final AuthenticationRepository authRepository;

  ForgotPassBloc({required this.authRepository}) : super(ForgotPassInitial()) {
    on<ForgotPassReset>((event, emit) async {
      await _mapForgotPassResetToState(event.email, emit);
    });
    on<ForgotPassOtpSend>((event, emit) async {
      await _mapForgotPassOtpSendToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to send mobile no to forgotPassword API and get otp
  Future<void> _mapForgotPassResetToState(
    String email,
    Emitter<ForgotPassState> emit,
  ) async {
    emit(ForgotPassProcessing());
    var internet = await checkInternet();

    if (!internet) {
      emit(ForgotPassError('No internet Connection.'));
      return;
    }

    try {
      var data = await authRepository.forgotPassword(email: email);

      emit(ForgotPassSent(data));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(ForgotPassMaintenanceError(message: e.message));
      } else if (e is InvalidStatusException) {
        emit(ForgotPassError(e.message));
      } else {
        emit(ForgotPassError(e.toString()));
      }
    }
  }

  // Function to send new password and otpcode to verify password API
  Future<void> _mapForgotPassOtpSendToState(
    ForgotPassOtpSend event,
    Emitter<ForgotPassState> emit,
  ) async {
    emit(ForgotPassProcessing());

    var internet = await checkInternet();

    if (!internet) {
      emit(ForgotPassError('No internet Connection.'));
      return;
    }

    try {
      var pwReset = await authRepository.verifyPasswordOtp(
        token: event.verifyToken,
        password: event.password,
        otpCode: event.otpCode,
      );

      emit(ForgotPassOtpVerified(message: pwReset['message']));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(ForgotPassMaintenanceError(message: e.message));
      } else if (e is InvalidStatusException) {
        emit(ForgotPassError(e.message));
      } else {
        emit(ForgotPassError(e.toString()));
      }
    }
  }
}
