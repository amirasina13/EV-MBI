import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../auth/auth.dart';
import '../login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthBloc authenticationBloc;

  LoginBloc({required this.userRepository, required this.authenticationBloc})
    : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to login
  Future<void> mapEventToState(event, Emitter<LoginState> emit) async {
    if (event is LoginPressed) {
      emit(LoginProcessing());

      var internet = await checkInternet();

      if (!internet) {
        emit(LoginNetworkError('No internet Connection.'));
        return;
      }

      try {
        var pushToken =
            await Storage().secureStorage.read(key: 'push_token') ?? '';

        var userEntity = UserEntity(
          id: event.email,
          email: event.email,
          password: event.password,
          access: 'mobile',
          isRemember: false,
          pushToken: pushToken,
        );

        var loginData = await userRepository.login(user: userEntity);

        authenticationBloc.add(
          AuthLoggedIn(
            token: loginData['data']['token'],
            loginData: loginData['data'],
          ),
        );

        emit(LoginFinished(loginData));
      } catch (e) {
        if (e is MaintenanceException) {
          emit(LoginMaintenanceError(message: e.message));
        } else if (e is InvalidStatusException) {
          emit(LoginError(e.message));
        } else {
          emit(LoginError(e.toString()));
        }
      }
    }
  }
}
