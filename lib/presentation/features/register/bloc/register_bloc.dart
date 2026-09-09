import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../register.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationRepository userRepository;

  RegisterBloc({required this.userRepository}) : super(RegisterInitial()) {
    on<RegisterVerify>((event, emit) async {
      await _mapRegisterVerifyToState(event, emit);
    });
    on<RegisterPressed>((event, emit) async {
      await _mapRegisterToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to verify register
  Future<void> _mapRegisterVerifyToState(
    RegisterVerify event,
    Emitter<RegisterState> emit,
  ) async {
    // normal register
    emit(RegisterProcessing());

    var internet = await checkInternet();

    if (!internet) {
      emit(RegisterNetworkError('No internet Connection.'));
      return;
    }

    try {
      final data = await userRepository.verifyRegister(email: event.email);

      emit(RegisterVerifySuccess(data));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(RegisterMaintenanceError(message: e.message));
      } else if (e is InvalidStatusException) {
        emit(RegisterError(e.message));
      } else {
        emit(RegisterError(e.toString()));
      }
    }
  }

  // Function to register user
  Future<void> _mapRegisterToState(
    RegisterPressed event,
    Emitter<RegisterState> emit,
  ) async {
    // normal register
    emit(RegisterProcessing());

    var internet = await checkInternet();

    if (!internet) {
      emit(RegisterNetworkError('No internet Connection.'));
      return;
    }

    try {
      final data = await userRepository.register(
        email: event.email,
        password: event.password,
        vToken: event.vToken,
      );

      emit(RegisterSuccess(data));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(RegisterMaintenanceError(message: e.message));
      } else if (e is InvalidStatusException) {
        emit(RegisterError(e.message));
      } else {
        emit(RegisterError(e.toString()));
      }
    }
  }
}
