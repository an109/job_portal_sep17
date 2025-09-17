import 'package:equatable/equatable.dart';
import '../../domain/entities/recruiter_application_entity.dart';

abstract class RecruiterApplicationState extends Equatable {
  const RecruiterApplicationState();

  @override
  List<Object?> get props => [];
}

class RecruiterApplicationInitial extends RecruiterApplicationState {}

class RecruiterApplicationLoading extends RecruiterApplicationState {}

class RecruiterApplicationLoaded extends RecruiterApplicationState {
  final List<RecruiterApplicationEntity> applications;

  const RecruiterApplicationLoaded(this.applications);

  @override
  List<Object?> get props => [applications];
}

class RecruiterApplicationError extends RecruiterApplicationState {
  final String message;

  const RecruiterApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}