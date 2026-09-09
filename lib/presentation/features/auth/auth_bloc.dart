import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import 'auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(AuthUninitialized()) {
    on<AuthAppStarted>((event, emit) async {
      await _mapAuthAppStartedEventToState(emit);
    });
    on<AuthChecking>((event, emit) async {
      await _mapAuthCheckingEventToState(emit);
    });
    on<AuthLoggedIn>((event, emit) async {
      await _mapAuthLoggedInEventToState(event.token, event.loginData, emit);
    });
    on<AuthLoggedOut>((event, emit) async {
      await _mapAuthenticatedLoggedOutEventToState(emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check is token verify or not
  Future<void> _mapAuthAppStartedEventToState(Emitter<AuthState> emit) async {
    // First, get token in storage
    var token = await _getToken();

    // Check the network
    var internet = await checkInternet();

    if (!internet) {
      emit(NetworkError(error: 'No internet Connection.'));
      return;
    }

    try {
      if (token != '') {
        if (Storage().fromPage == 'scan') {
          emit(AuthTokenNotEmpty());
        } else {
          // verify token first by calling the verifyToken API
          var verifiedToken = await userRepository.verifyToken(token: token);

          // if token is verified, go to _mapAuthenticatedLoggedInEventToState
          // will show splashLogin -> homepage
          if (verifiedToken['status'] == true) {
            Storage().token = token;
            await _saveToken(token);

            emit(AuthAuthenticated(loginData: verifiedToken['data']));
            // if not, will call country API and show login screen
          } else {
            // countryBloc.add(CountryLoad());
            emit(AuthUnauthenticated());
          }
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      if (e is MaintenanceException) {
        emit(AuthMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(AuthSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(AuthError(error: e.message));
        emit(AuthUnauthenticated());
      } else {
        emit(AuthError(error: e.toString()));
      }
    }
  }

  // Function to check is token verify or not
  Future<void> _mapAuthCheckingEventToState(Emitter<AuthState> emit) async {
    // First, get token in storage
    var token = await _getToken();

    // Check the network
    var internet = await checkInternet();

    if (!internet) {
      try {
        if (token != '') {
          // if not, will call country API and show login screen
          emit(AuthTokenNotEmpty());
        } else {
          emit(AuthTokenEmpty());
        }

        // }
      } catch (e) {
        if (e is InvalidStatusException) {
          emit(AuthError(error: e.message));
        } else {
          emit(AuthError(error: e.toString()));
        }
      }
      // }
    } else {
      emit(NetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to login
  Future<void> _mapAuthLoggedInEventToState(
    String token,
    Map loginData,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _saveToken(token);
      // if got token, save token in storage
      Storage().token = token;

      emit(AuthAuthenticated(loginData: loginData));
    } catch (e) {
      if (e is InvalidNetworkException) {
        emit(NetworkError(error: e.message));
      }
    }
  }

  // Function to logout
  Future<void> _mapAuthenticatedLoggedOutEventToState(
    Emitter<AuthState> emit,
  ) async {
    // remove token in storage
    await _deleteToken();
    Storage().token = '';

    // profileBloc.add(ProfileStart());
    // then call countryLoad event, then show loginScreen
    // countryBloc.add(CountryLoad());

    emit(AuthUnauthenticated());
  }

  /// write to keystore/keychain
  Future<void> _saveToken(String token) async {
    await Storage().secureStorage.write(key: 'token', value: token);
  }

  /// read to keystore/keychain
  Future<String> _getToken() async {
    return await Storage().secureStorage.read(key: 'token') ?? '';
  }

  /// delete from keystore/keychain
  Future<void> _deleteToken() async {
    await Storage().secureStorage.delete(key: 'token');
  }
}
