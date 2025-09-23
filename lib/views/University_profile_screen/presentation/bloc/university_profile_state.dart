import 'package:equatable/equatable.dart';
import '../../domain/entities/university_profile_entity.dart';

abstract class UniversityProfileState extends Equatable {
  const UniversityProfileState();

  @override
  List<Object?> get props => [];
}
class UniversityProfileNotFound extends UniversityProfileState {
  UniversityProfileNotFound();

  @override
  List<Object> get props => [];
}

class UniversityProfileInitial extends UniversityProfileState {}

class UniversityProfileLoading extends UniversityProfileState {}

class UniversityProfileSuccess extends UniversityProfileState {
  final UniversityProfileEntity entity;

  const UniversityProfileSuccess(this.entity);

  @override
  List<Object?> get props => [entity];
}

class UniversityProfileFailure extends UniversityProfileState {
  final String message;

  const UniversityProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}