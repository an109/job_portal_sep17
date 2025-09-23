import 'package:equatable/equatable.dart';

abstract class UniversityFollowersFollowingEvent extends Equatable {
  const UniversityFollowersFollowingEvent();

  @override
  List<Object> get props => [];
}

class LoadFollowers extends UniversityFollowersFollowingEvent {
  final int userId;

  const LoadFollowers(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadFollowing extends UniversityFollowersFollowingEvent {
  final int userId;

  const LoadFollowing(this.userId);

  @override
  List<Object> get props => [userId];
}