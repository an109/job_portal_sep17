import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/user_profile/data/models/public_profile_model.dart';
import 'package:job_portal/views/user_profile/domain/entities/followers_entity.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class PublicProfileLoading extends ProfileState {
  const PublicProfileLoading();
}

class PublicProfileLoaded extends ProfileState {
  final UserProfileModel publicProfile;

  const PublicProfileLoaded(this.publicProfile);
}

class PublicProfileError extends ProfileState {
  const PublicProfileError();
}

class PublicProfileWithFollowersAndFollowingLoading extends ProfileState {
  const PublicProfileWithFollowersAndFollowingLoading();
}

class PublicProfileWithFollowersAndFollowingLoaded extends ProfileState {
  final UserProfileModel publicProfile;
  final FollowersEntity followersEntity;
  final FollowingEntity followingEntity;

  const PublicProfileWithFollowersAndFollowingLoaded(
      this.publicProfile, this.followersEntity, this.followingEntity);
}

class PublicProfileWithFollowersAndFollowingError extends ProfileState {
  const PublicProfileWithFollowersAndFollowingError();
}
