import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadPublicProfile extends ProfileEvent {
  final String id;

  const LoadPublicProfile(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadPublicProfileWithFollowersAndFollowing extends ProfileEvent {
  final String id;

  const LoadPublicProfileWithFollowersAndFollowing(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
