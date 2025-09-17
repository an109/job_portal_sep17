import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/user_profile/domain/entities/update_user_profile_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';

@immutable
abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MyProfileInitial extends MyProfileState {
  const MyProfileInitial();
}

class ResumeLoading extends MyProfileState {
  const ResumeLoading();
}

class ResumeLoaded extends MyProfileState {
  const ResumeLoaded();
}

class ResumeLoadError extends MyProfileState {
  const ResumeLoadError();
}

class MyProfileDetailsLoading extends MyProfileState {
  const MyProfileDetailsLoading();
}

class MyProfileDetailsLoaded extends MyProfileState {
  final UserDetailEntity userDetailEntity;

  const MyProfileDetailsLoaded(this.userDetailEntity);
}

class MyProfileDetailsError extends MyProfileState {
  const MyProfileDetailsError();
}

class UpdateProfileLoading extends MyProfileState {
  const UpdateProfileLoading();
}

class UpdateProfileLoaded extends MyProfileState {
  final UpdateUserProfileEntity updateUserProfileEntity;

  const UpdateProfileLoaded(this.updateUserProfileEntity);
}

class UpdateProfileError extends MyProfileState {
  const UpdateProfileError();
}
