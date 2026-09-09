import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/data.dart';

@immutable
abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class HistoryInitial extends HistoryState {}

@immutable
class HistoryProcessing extends HistoryState {}

@immutable
class HistoryLoading extends HistoryState {}

@immutable
class HistoryDetailsLoading extends HistoryState {}

@immutable
class HistoryNextLoading extends HistoryState {}

@immutable
class HistoryLoaded extends HistoryState {
  final History history;

  HistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];

  @override
  String toString() => '${history.records!.length} History List Loaded';
}

@immutable
class HistoryDetailsLoaded extends HistoryState {
  final HistoryDetail historyDetails;

  HistoryDetailsLoaded({required this.historyDetails});

  @override
  List<Object> get props => [historyDetails];

  @override
  String toString() =>
      'History Details (${historyDetails.locationName}) Loaded';
}

@immutable
class HistoryTokenEmpty extends HistoryState {}

@immutable
class HistoryEmpty extends HistoryState {}

@immutable
class HistoryDetailsEmpty extends HistoryState {}

@immutable
class HistoryListStop extends HistoryState {}

@immutable
class HistoryDetailsRefresh extends HistoryState {}

@immutable
class HistoryError extends HistoryState {
  final String error;

  HistoryError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class HistoryNetworkError extends HistoryState {
  final String error;

  HistoryNetworkError(this.error);

  @override
  List<Object> get props => [error];
}

@immutable
class HistorySessionError extends HistoryState {
  final String error;

  HistorySessionError({required this.error});

  @override
  List<Object> get props => [error];
}

@immutable
class HistoryMaintenanceError extends HistoryState {
  final String message;

  HistoryMaintenanceError({required this.message});

  @override
  List<Object> get props => [message];
}
