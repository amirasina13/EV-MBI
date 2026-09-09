import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class MapCheck extends MapEvent {}

@immutable
class MapLocationEnable extends MapEvent {}

@immutable
class MapLocationDisable extends MapEvent {}
