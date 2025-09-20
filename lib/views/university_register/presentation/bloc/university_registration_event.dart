import 'package:equatable/equatable.dart';
import '../../domain/entities/university_registration_entity.dart';

abstract class UniversityRegistrationEvent extends Equatable {
  const UniversityRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegisterUniversityEvent extends UniversityRegistrationEvent {
  final UniversityRegistrationEntity entity;

  const RegisterUniversityEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}