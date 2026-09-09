import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../config/config.dart';
import '../map.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
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

  MapBloc() : super(MapInitial()) {
    on<MapCheck>((event, emit) async {
      if (state is MapStarted) {
        await _mapMapCheckEventToState(event, emit);
      } else {
        await _mapMapCheckEventToState(event, emit);
      }
    });
    on<MapLocationEnable>((event, emit) async {
      await initialize();
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await _location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location!.requestService();
        if (!serviceEnabled) {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(
            MapStarted(
              currentLatitude: double.parse(currentLatitude!),
              currentLongitude: double.parse(currentLongitude!),
            ),
          );
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
            emit(MapLocationDisabled());
          } else {
            currentLatitude = Storage().latitude;
            currentLongitude = Storage().longitude;

            emit(
              MapStarted(
                currentLatitude: double.parse(currentLatitude!),
                currentLongitude: double.parse(currentLongitude!),
              ),
            );
          }
          return;
        }
      }
      add(MapCheck());
    });
    on<MapLocationDisable>((event, emit) async {
      currentLatitude = Storage().latitude;
      currentLongitude = Storage().longitude;

      emit(
        MapStarted(
          currentLatitude: double.parse(currentLatitude!),
          currentLongitude: double.parse(currentLongitude!),
        ),
      );

      // emit(MapLocationDisabled());
    });
  }

  Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return !connectionResult.contains(ConnectivityResult.none);
  }

  // Function to check location enable
  Future<void> _mapMapCheckEventToState(event, Emitter<MapState> emit) async {
    if (isReload == false) {
      emit(MapLoading());
    }

    bool serviceEnabled = await _isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (Storage().locPermission == 'disable') {
        currentLatitude = Storage().latitude;
        currentLongitude = Storage().longitude;

        emit(
          MapStarted(
            currentLatitude: double.parse(currentLatitude!),
            currentLongitude: double.parse(currentLongitude!),
          ),
        );
      } else {
        if (Storage().lastUpdateLoc.isEmpty &&
            Storage().lastUpdateLoc != dateNow) {
          emit(MapLocationRequested());
        } else {
          currentLatitude = Storage().latitude;
          currentLongitude = Storage().longitude;

          emit(
            MapStarted(
              currentLatitude: double.parse(currentLatitude!),
              currentLongitude: double.parse(currentLongitude!),
            ),
          );
        }
      }
      // emit(MapLocationRequested());
    } else {
      await initialize();
      emit(
        MapStarted(
          currentLatitude: double.parse(currentLatitude!),
          currentLongitude: double.parse(currentLongitude!),
        ),
      );
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
