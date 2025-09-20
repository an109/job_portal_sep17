import 'package:equatable/equatable.dart';
import '../../domain/entities/university_registration_entity.dart';

abstract class UniversityRegistrationState extends Equatable {
  const UniversityRegistrationState();

  @override
  List<Object?> get props => [];
}

class UniversityRegistrationInitial extends UniversityRegistrationState {}

class UniversityRegistrationLoading extends UniversityRegistrationState {}

class UniversityRegistrationSuccess extends UniversityRegistrationState {
  final UniversityRegistrationEntity entity;

  const UniversityRegistrationSuccess(this.entity);

  @override
  List<Object?> get props => [entity];
}

class UniversityRegistrationFailure extends UniversityRegistrationState {
  final String message;

  const UniversityRegistrationFailure(this.message);

  @override
  List<Object?> get props => [message];
}