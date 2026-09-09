import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  bool reloadBack = false;

  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<ProfileStart>((event, emit) async {
      emit(ProfileInitial());
    });
    on<ProfileLoad>((event, emit) async {
      await _mapProfileLoadEventToState(event, emit);
    });
    on<ProfilePhotoUpdate>((event, emit) async {
      await _mapProfilePhotoUpdateEventToState(event, emit);
    });
    on<ProfileUpdate>((event, emit) async {
      await _mapProfileUpdateEventToState(event, emit);
    });
    on<ProfileEditLoad>((event, emit) async {
      await _mapProfileEditLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get profile info/ user details
  Future<void> _mapProfileLoadEventToState(
    ProfileLoad event,
    Emitter<ProfileState> emit,
  ) async {
    var token = await _getToken();
    var internet = await checkInternet();

    if (!internet) {
      emit(ProfileNetworkError(error: 'No internet Connection.'));
      return;
    }

    try {
      if (token.isNotEmpty) {
        if (state is! ProfileUpdating) {
          // yield ProfileProcessing();
        }

        var userProfile = await userRepository.getUserProfile(token: token);

        emit(ProfileLoaded(userProfile: userProfile));
      } else {
        emit(ProfileTokenEmpty());
      }
    } catch (e) {
      if (e is MaintenanceException) {
        emit(ProfileMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(ProfileSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(ProfileError(error: e.message));
      } else {
        emit(ProfileError(error: e.toString()));
      }
    }
  }

  // Function to update profile photo to API
  Future<void> _mapProfilePhotoUpdateEventToState(
    ProfilePhotoUpdate event,
    Emitter<ProfileState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      emit(ProfileNetworkError(error: 'No internet Connection.'));
      return;
    }

    try {
      emit(ProfilePhotoUpdating());
      var updatePhoto = await userRepository.updateProfilePhoto(
        token: Storage().token,
        image: event.image,
      );

      emit(ProfilePhotoUpdated(message: updatePhoto['message']));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(ProfileMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(ProfileSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(ProfileError(error: e.message));
      } else {
        emit(ProfileError(error: e.toString()));
      }
    }
  }

  //  Function to update profile info/ user details
  Future<void> _mapProfileUpdateEventToState(
    ProfileUpdate event,
    Emitter<ProfileState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      emit(ProfileNetworkError(error: 'No internet Connection.'));
      return;
    }

    try {
      emit(ProfileUpdating());
      var profileUpdated = await userRepository.updateProfile(
        token: Storage().token,
        name: event.name,
        surname: event.surname,
        forename: event.forename,
        contact: event.contact,
      );

      emit(ProfileUpdated(message: profileUpdated['message']));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(ProfileMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(ProfileSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(ProfileError(error: e.message));
      } else {
        emit(ProfileError(error: e.toString()));
      }
    }
  }

  // Function to update profile info/ user details after register
  Future<void> _mapProfileEditLoadEventToState(
    ProfileEditLoad event,
    Emitter<ProfileState> emit,
  ) async {
    var internet = await checkInternet();

    if (!internet) {
      emit(ProfileEditLoaded(errorField: event.errorField));
    } else {
      emit(ProfileNetworkError(error: 'No internet Connection.'));
    }
  }

  /// read to keystore/keychain
  Future<String> _getToken() async {
    return await Storage().secureStorage.read(key: 'token') ?? '';
  }
}
