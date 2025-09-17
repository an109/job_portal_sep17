import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordOtpSent extends ForgotPasswordState {
  final String message;

  const ForgotPasswordOtpSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordOtpFailed extends ForgotPasswordState {
  final String error;

  const ForgotPasswordOtpFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class ResetPasswordLoading extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailed extends ForgotPasswordState {
  final String error;

  const ResetPasswordFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class ResetPasswordWithOTPLoading extends ForgotPasswordState {}

class ResetPasswordWithOTPSuccess extends ForgotPasswordState {
  final String message;

  const ResetPasswordWithOTPSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordWithOTPFailed extends ForgotPasswordState {
  final String error;

  const ResetPasswordWithOTPFailed(this.error);

  @override
  List<Object?> get props => [error];
}