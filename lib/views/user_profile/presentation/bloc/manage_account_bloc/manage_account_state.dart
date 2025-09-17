import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_email_entity.dart';

@immutable
abstract class ManageAccountState extends Equatable {
  const ManageAccountState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ManageAccountInitial extends ManageAccountState {
  const ManageAccountInitial();
}

class ChangeEmailLoading extends ManageAccountState {
  const ChangeEmailLoading();
}

class ChangeEmailLoaded extends ManageAccountState {
  final UpdateUserEmailEntity updateUserEmailEntity;

  const ChangeEmailLoaded(this.updateUserEmailEntity);
}

class ChangeEmailError extends ManageAccountState {
  final String message;

  const ChangeEmailError([this.message = 'Unknown error']);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordLoading extends ManageAccountState {}

class ChangePasswordLoaded extends ManageAccountState {
  final String message;
  ChangePasswordLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordError extends ManageAccountState {
  final String message;
  ChangePasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
