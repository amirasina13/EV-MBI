import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MapState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class MapInitial extends MapState {}

@immutable
class MapLoading extends MapState {}

@immutable
class MapStarted extends MapState {
  final double currentLatitude;
  final double currentLongitude;

  MapStarted({required this.currentLatitude, required this.currentLongitude});

  @override
  List<Object> get props => [currentLatitude, currentLongitude];
}

@immutable
class MapLocationRequested extends MapState {}

@immutable
class MapEnableStarted extends MapState {}

@immutable
class MapLocationDisabled extends MapState {}

@immutable
class MapEmpty extends MapState {}

@immutable
class MapError extends MapState {
  final String error;

  MapError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class MapNetworkError extends MapState {
  final String error;

  MapNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class MapSessionError extends MapState {
  final String error;

  MapSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class MapMaintenanceError extends MapState {
  final String message;

  MapMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
