import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:job_portal/views/signup_recruiter/domain/entities/sigup_user_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';

@immutable
abstract class RecruiterSignupState extends Equatable {
  const RecruiterSignupState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RecruiterSignupInitialize extends RecruiterSignupState {
  const RecruiterSignupInitialize();
}

class RecruiterSignupLoading extends RecruiterSignupState {
  const RecruiterSignupLoading();
}

class RecruiterSignupLoaded extends RecruiterSignupState {
  // ignore: unused_field
  final SignUpUserEntity signUpUserEntity;

  const RecruiterSignupLoaded(this.signUpUserEntity);
}

class RecruiterSignupError extends RecruiterSignupState {
  const RecruiterSignupError();
}

class RecruiterSignupSendOtpLoading extends RecruiterSignupState {
  const RecruiterSignupSendOtpLoading();
}

class RecruiterSignupSendOtpLoaded extends RecruiterSignupState {
  final SendOtpEmailEntity sendOtpEmail;

  const RecruiterSignupSendOtpLoaded(this.sendOtpEmail);
}

class RecruiterSignupSendOtpError extends RecruiterSignupState {
  const RecruiterSignupSendOtpError();
}
