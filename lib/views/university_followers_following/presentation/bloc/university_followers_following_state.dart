// lib/presentation/bloc/university_followers_following_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/university_followers_following_entity.dart';

abstract class UniversityFollowersFollowingState extends Equatable {
  const UniversityFollowersFollowingState();

  @override
  List<Object> get props => [];
}

class InitialUniversityFollowersFollowingState extends UniversityFollowersFollowingState {}

class FollowersLoading extends UniversityFollowersFollowingState {}

class FollowersLoaded extends UniversityFollowersFollowingState {
  final List<UniversityFollowerFollowingEntity> followers;

  const FollowersLoaded(this.followers);

  @override
  List<Object> get props => [followers];
}

class FollowersError extends UniversityFollowersFollowingState {
  final String message;

  const FollowersError(this.message);

  @override
  List<Object> get props => [message];
}

class FollowingLoading extends UniversityFollowersFollowingState {}

class FollowingLoaded extends UniversityFollowersFollowingState {
  final List<UniversityFollowerFollowingEntity> following;

  const FollowingLoaded(this.following);

  @override
  List<Object> get props => [following];
}

class FollowingError extends UniversityFollowersFollowingState {
  final String message;

  const FollowingError(this.message);

  @override
  List<Object> get props => [message];
}