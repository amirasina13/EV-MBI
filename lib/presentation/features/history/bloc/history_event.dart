import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HistoryListLoading extends HistoryEvent {}

@immutable
class HistoryListLoad extends HistoryEvent {}

@immutable
class HistoryDetailsLoad extends HistoryEvent {
  final String id;

  HistoryDetailsLoad({required this.id});

  @override
  List<Object> get props => [id];
}
