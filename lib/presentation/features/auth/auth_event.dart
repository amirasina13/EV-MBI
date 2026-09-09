import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/* Events tell BLoC to do something. An event can be fired from anywhere, such as from a UI widget. 
External events, such as changes in network connectivity, changes in sensor readings */

/* Events class are an application’s inputs (like button_press to load images, text inputs, or any 
other user input that our app may hope to receive) */

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class AuthAppStarted extends AuthEvent {
  @override
  String toString() => 'AuthAppStarted';
}

@immutable
class AuthLoggedIn extends AuthEvent {
  final String token;
  final Map loginData;

  AuthLoggedIn({required this.token, required this.loginData});

  @override
  List<Object> get props => [token, loginData];

  @override
  String toString() => 'AuthLoggedIn';
}

@immutable
class AuthLoggedOut extends AuthEvent {
  @override
  String toString() => 'AuthLoggedOut';
}

@immutable
class AuthChecking extends AuthEvent {
  @override
  String toString() => 'AuthChecking';
}
