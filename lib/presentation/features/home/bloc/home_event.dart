import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HomeCheck extends HomeEvent {}

@immutable
class HomeLoad extends HomeEvent {}

@immutable
class LocationListLoad extends HomeEvent {}

@immutable
class LocationDetailsLoad extends HomeEvent {
  final String uuid;

  LocationDetailsLoad({required this.uuid});

  @override
  List<Object> get props => [uuid];
}

@immutable
class HomeLocationEnable extends HomeEvent {}

@immutable
class HomeLocationDisable extends HomeEvent {}
