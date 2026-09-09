import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ScanState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ScanInitial extends ScanState {}

@immutable
class ScanProcessing extends ScanState {}

@immutable
class ScanTokenEmpty extends ScanState {}

@immutable
class ScanSuccess extends ScanState {
  final Map scanResult;

  ScanSuccess({required this.scanResult});

  @override
  List<Object> get props => [scanResult];
}

@immutable
class ScanFailure extends ScanState {}

@immutable
class ScanError extends ScanState {
  final String error;

  ScanError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ScanNetworkError extends ScanState {
  final String error;

  ScanNetworkError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ScanSessionError extends ScanState {
  final String error;

  ScanSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ScanException extends ScanState {
  final String error;

  ScanException({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class ScanMaintenanceError extends ScanState {
  final String message;

  ScanMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
