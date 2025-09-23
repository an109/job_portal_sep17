import 'package:equatable/equatable.dart';
import '../../data/models/university_public_profile_model.dart';
import '../../domain/entities/university_public_profile_entity.dart';

abstract class UniversityPublicProfileState extends Equatable {
  const UniversityPublicProfileState();

  @override
  List<Object?> get props => [];
}

class UniversityPublicProfileInitial extends UniversityPublicProfileState {}

class UniversityPublicProfileLoading extends UniversityPublicProfileState {}

class UniversityPublicProfileLoaded extends UniversityPublicProfileState {
  final UniversityPublicProfileEntity profile;

  const UniversityPublicProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UniversityPublicProfileError extends UniversityPublicProfileState {
  final String message;

  const UniversityPublicProfileError(this.message);

  @override
  List<Object?> get props => [message];
}