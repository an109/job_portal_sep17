import 'package:equatable/equatable.dart';

abstract class UniversityPublicProfileEvent extends Equatable {
  const UniversityPublicProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUniversityPublicProfile extends UniversityPublicProfileEvent {
  final int userId;

  const FetchUniversityPublicProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}