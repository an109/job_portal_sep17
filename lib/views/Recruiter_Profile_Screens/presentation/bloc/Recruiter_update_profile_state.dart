import 'package:equatable/equatable.dart';

abstract class RecruiterUpdateProfileState extends Equatable {
  const RecruiterUpdateProfileState();

  @override
  List<Object> get props => [];
}

class InitialState extends RecruiterUpdateProfileState {}

class LoadingState extends RecruiterUpdateProfileState {}

class SuccessState extends RecruiterUpdateProfileState {
  final String message;

  const SuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class ErrorState extends RecruiterUpdateProfileState {
  final String error;

  const ErrorState(this.error);

  @override
  List<Object> get props => [error];
}