import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ScanEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class ScanLoad extends ScanEvent {
  final String scanCode;

  ScanLoad({required this.scanCode});

  @override
  List<Object> get props => [scanCode];
}
