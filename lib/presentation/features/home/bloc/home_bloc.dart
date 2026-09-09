import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../../../locator.dart';
import '../home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final LocationDetailGetUseCase _locationDetailGetUseCase;

  Location? _location;
  geoloc.Position? _currentLoc;
  geoloc.LocationAccuracyStatus? accuracy;
  String? currentLatitude,
      currentLongitude,
      saveCurrentLatitude,
      saveCurrentLongitude;
  bool isReload = false;

  late var now = DateTime.now();
  late var format = DateFormat('yyyy-MM-dd');
  late String dateNow = format.format(now);

  initialize() async {
    _location ??= Location();

    // region fail-safe
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location!.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location!.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location!.hasPermission();
    await geoloc.Geolocator.getLocationAccuracy()
        .then((value) {
          if (value == geoloc.LocationAccuracyStatus.reduced) {
            accuracy = geoloc.LocationAccuracyStatus.reduced;
          }
        })
        .catchError((e) {});

    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever ||
        permissionGranted == PermissionStatus.grantedLimited) {
      if (accuracy != geoloc.LocationAccuracyStatus.reduced &&
          accuracy != geoloc.LocationAccuracyStatus.precise) {
        permissionGranted = await _location!.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    }

    if (Storage().latitude!.isNotEmpty && Storage().longitude!.isNotEmpty) {
      currentLatitude = Storage().latitude;
      currentLongitude = Storage().longitude;
    } else {
      _currentLoc = await _getCurrentLocation();
      if (_currentLoc != null) {
        currentLatitude = _currentLoc!.latitude.toString();
        currentLongitude = _currentLoc!.longitude.toString();
      }
    }
  }

  HomeBloc()
    : homeRepository = sl(),
      _locationDetailGetUseCase = sl(),
      super(HomeInitial()) {
    on<HomeCheck>((event, emit) async {
      if (state is HomeStarted) {
        await _mapHomeCheckEventToState(event, emit);
      } else {
        await _mapHomeCheckEventToState(event, emit);
      }
    });
    on<HomeLoad>((event, emit) async {
      await _mapHomeLoadEventToState(event, emit);
    });
    on<LocationDetailsLoad>((event, emit) async {
      await _mapLocationDetailLoadEventToState(event, emit);
    });
    on<HomeLocationEnable>((event, emit) async {
      await initialize();
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await _location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location!.requestService();
        if (!serviceEnabled) {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(HomeStarted());
          return;
        }
      }

      permissionGranted = await _location!.hasPermission();

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location!.requestPermission();

        if (permissionGranted == PermissionStatus.granted) {
          Location.instance.changeSettings(accuracy: (LocationAccuracy.high));

          if (Storage().latitude!.isNotEmpty &&
              Storage().longitude!.isNotEmpty) {
            currentLatitude = Storage().latitude;
            currentLongitude = Storage().longitude;
          } else {
            _currentLoc = await _getCurrentLocation();
            if (_currentLoc != null) {
              currentLatitude = _currentLoc!.latitude.toString();
              currentLongitude = _currentLoc!.longitude.toString();
            }
          }

          return;
        }

        if (permissionGranted == PermissionStatus.denied ||
            permissionGranted == PermissionStatus.deniedForever ||
            permissionGranted == PermissionStatus.grantedLimited) {
          if (accuracy == geoloc.LocationAccuracyStatus.reduced) {
            if (Storage().latitude!.isNotEmpty &&
                Storage().longitude!.isNotEmpty) {
              currentLatitude = Storage().latitude;
              currentLongitude = Storage().longitude;
            } else {
              _currentLoc = await _getCurrentLocation();
              if (_currentLoc != null) {
                currentLatitude = _currentLoc!.latitude.toString();
                currentLongitude = _currentLoc!.longitude.toString();
              }
            }

            return;
          }
        }

        if (permissionGranted != PermissionStatus.granted) {
          if (Platform.isAndroid) {
            emit(HomeLocationDisabled());
          } else {
            currentLatitude = Storage().latitude;
            currentLongitude = Storage().longitude;

            emit(HomeStarted());
          }
          return;
        }
      }
      add(HomeCheck());
    });
    on<HomeLocationDisable>((event, emit) async {
      currentLatitude = Storage().latitude;
      currentLongitude = Storage().longitude;

      emit(HomeStarted());
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check location enable
  Future<void> _mapHomeCheckEventToState(event, Emitter<HomeState> emit) async {
    if (isReload == false) {
      emit(HomeLoading());
    }

    bool serviceEnabled = await _isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (Storage().locPermission == 'disable') {
        currentLatitude = Storage().latitude;
        currentLongitude = Storage().longitude;

        emit(HomeStarted());
      } else {
        if (Storage().lastUpdateLoc.isEmpty &&
            Storage().lastUpdateLoc != dateNow) {
          emit(HomeLocationRequested());
        } else {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(HomeStarted());
        }
      }
    } else {
      await initialize();
      emit(HomeStarted());
    }
  }

  Future<void> _mapHomeLoadEventToState(
    HomeLoad event,
    Emitter<HomeState> emit,
  ) async {
    var internet = await checkInternet();
    await initialize();

    if (!internet) {
      emit(HomeNetworkError(error: 'No internet Connection.'));
      return;
    }

    try {
      var getHome = await homeRepository.getHomePage(
        currentLatitude!,
        currentLongitude!,
      );

      emit(HomeLoaded(homePage: getHome));
    } catch (e) {
      if (e is MaintenanceException) {
        emit(HomeMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(HomeSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(HomeError(error: e.message));
      } else {
        emit(HomeError(error: e.toString()));
      }
    }
  }

  // Function to get location detail
  Future<void> _mapLocationDetailLoadEventToState(
    event,
    Emitter<HomeState> emit,
  ) async {
    emit(LocationDetailsLoading());

    // check internet connection first
    var internet = await checkInternet();
    await initialize();

    if (!internet) {
      emit(HomeNetworkError(error: 'No internet Connection.'));
      return;
    }

    try {
      var locationDetailsGetResults = await _locationDetailGetUseCase.execute(
        LocationDetailGetParams(
          uuid: event.uuid,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
        ),
      );
      // declare the details
      var details = locationDetailsGetResults.details;

      // if details is null or no value, state will be LocationDetailsEmpty
      if (details == null) {
        emit(LocationDetailsEmpty());
        // else state will be LocationDetailsLoaded
      } else {
        saveCurrentLatitude = currentLatitude;
        saveCurrentLongitude = currentLongitude;

        emit(LocationDetailsLoaded(details: details));
      }
    } catch (e) {
      if (e is MaintenanceException) {
        emit(HomeMaintenanceError(message: e.message));
      } else if (e is InvalidSessionException) {
        emit(HomeSessionError(error: e.message));
      } else if (e is InvalidStatusException) {
        emit(HomeError(error: e.message));
      } else {
        emit(HomeError(error: e.toString()));
      }
    }
  }

  Future<bool> _isLocationServiceEnabled() async {
    _location ??= Location();

    bool serviceEnabled = await _location!.serviceEnabled();
    PermissionStatus permissionGranted = await _location!.hasPermission();

    await geoloc.Geolocator.getLocationAccuracy()
        .then((value) {
          if (value == geoloc.LocationAccuracyStatus.reduced) {
            accuracy = geoloc.LocationAccuracyStatus.reduced;
          }
        })
        .catchError((e) {});

    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      if (accuracy == geoloc.LocationAccuracyStatus.reduced) {
        return serviceEnabled &&
            accuracy == geoloc.LocationAccuracyStatus.reduced;
      }
    }

    if (Platform.isIOS &&
        permissionGranted == PermissionStatus.grantedLimited) {
      return (serviceEnabled &&
          permissionGranted == PermissionStatus.grantedLimited);
    }

    return (serviceEnabled && permissionGranted == PermissionStatus.granted);
  }

  Future<geoloc.Position?> _getCurrentLocation() async {
    geoloc.Position? currentPosition;

    final geoloc.LocationSettings locationSettings = geoloc.LocationSettings(
      accuracy: geoloc.LocationAccuracy.best,
      distanceFilter: 100,
      timeLimit: Duration(seconds: 5),
    );

    try {
      currentPosition = await geoloc.Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (e) {
      currentPosition = await geoloc.Geolocator.getLastKnownPosition();
      e;
    }

    return currentPosition;
  }
}
