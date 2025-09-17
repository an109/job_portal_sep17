import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

@immutable
abstract class VerifyOtpRecruiterState extends Equatable {
  const VerifyOtpRecruiterState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class VerifyOtpRecruiterInitial extends VerifyOtpRecruiterState {
  const VerifyOtpRecruiterInitial();
}

class VerifyOtpRecruiterLoading extends VerifyOtpRecruiterState {
  const VerifyOtpRecruiterLoading();
}

class VerifyOtpRecruiterLoaded extends VerifyOtpRecruiterState {
  final VerifyOtpEntity verifyOtpEntity;

  const VerifyOtpRecruiterLoaded(this.verifyOtpEntity);
}

class VerifyOtpRecruiterError extends VerifyOtpRecruiterState {
  const VerifyOtpRecruiterError();
}
