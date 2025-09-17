import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

@immutable
abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {
  const VerifyOtpInitial();
}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

class VerifyOtpLoaded extends VerifyOtpState {
  final VerifyOtpEntity verifyOtpEntity;

  const VerifyOtpLoaded(this.verifyOtpEntity);
}

class VerifyOtpError extends VerifyOtpState {
  const VerifyOtpError();
}
