import 'package:equatable/equatable.dart';
import '../../domain/entities/university_profile_entity.dart';

abstract class UniversityProfileEvent extends Equatable {
  const UniversityProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUniversityProfile extends UniversityProfileEvent {}

class SaveUniversityProfile extends UniversityProfileEvent {
  final UniversityProfileEntity entity;

  const SaveUniversityProfile(this.entity);

  @override
  List<Object?> get props => [entity];
}