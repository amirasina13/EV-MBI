import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class AuthUninitialized extends AuthState {}

@immutable
class AuthAuthenticated extends AuthState {
  final Map loginData;

  AuthAuthenticated({required this.loginData});

  @override
  List<Object> get props => [loginData];
}

@immutable
class AuthChecked extends AuthState {
  final Map loginData;

  AuthChecked({required this.loginData});

  @override
  List<Object> get props => [loginData];
}

@immutable
class AuthUnauthenticated extends AuthState {}

@immutable
class AuthTokenEmpty extends AuthState {}

@immutable
class AuthTokenNotEmpty extends AuthState {}

@immutable
class AuthError extends AuthState {
  final String error;

  AuthError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class AuthSessionError extends AuthState {
  final String error;

  AuthSessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class AuthMaintenanceError extends AuthState {
  final String message;

  AuthMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}

@immutable
class NetworkError extends AuthState {
  final String error;

  NetworkError({required this.error});

  @override
  List<Object> get props => [error];
}
