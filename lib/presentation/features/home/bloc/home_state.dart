import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/data.dart';

@immutable
abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HomeInitial extends HomeState {}

@immutable
class HomeLoading extends HomeState {}

@immutable
class HomeStarted extends HomeState {}

@immutable
class HomeLoaded extends HomeState {
  final Homepage homePage;

  HomeLoaded({required this.homePage});

  @override
  String toString() => 'HomeLoaded';
}

@immutable
class HomeLocationRequested extends HomeState {}

@immutable
class HomeEnableStarted extends HomeState {}

@immutable
class LocationListLoaded extends HomeState {
  final dynamic locations;

  LocationListLoaded({required this.locations});

  @override
  List<Object> get props => [locations];

  @override
  String toString() => '${locations.length} Location List Loaded';
}

@immutable
class LocationDetailsEmpty extends HomeState {}

@immutable
class LocationDetailsLoading extends HomeState {}

@immutable
class LocationDetailsLoaded extends HomeState {
  final LocationDetail details;

  LocationDetailsLoaded({required this.details});

  @override
  List<Object> get props => [details];

  @override
  String toString() => 'Location Details Loaded';
}

@immutable
class HomeEmpty extends HomeState {}

@immutable
class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HomeNetworkError extends HomeState {
  final String error;

  HomeNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HomeSessionError extends HomeState {
  final String error;

  HomeSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HomeMaintenanceError extends HomeState {
  final String message;

  HomeMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}

@immutable
class HomeLocationDisabled extends HomeState {}
