import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendForgotPasswordEmail extends ForgotPasswordEvent {
  final String email;

  const SendForgotPasswordEmail({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequestEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordRequestEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

class ResetPasswordWithOTPRequestEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordWithOTPRequestEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}
