import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/detailed_signup_student/data/model/basic_user_data_response.dart';
import 'package:job_portal/views/signup_student/data/models/signup_user_response.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';

@immutable
abstract class RemoteSignupState extends Equatable {
  const RemoteSignupState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RemoteSignupInitial extends RemoteSignupState {
  const RemoteSignupInitial();
}

class RemoteSignupLoading extends RemoteSignupState {
  const RemoteSignupLoading();
}

class RemoteSignupDone extends RemoteSignupState {
  final SignUpUserResponse signUpUserResponse;

  const RemoteSignupDone(this.signUpUserResponse);
}

class RemoteSignupError extends RemoteSignupState {
  const RemoteSignupError();
}

class RemoteSignupSendOtpEmailLoading extends RemoteSignupState {
  const RemoteSignupSendOtpEmailLoading();
}

class RemoteSignupSendOtpEmailDone extends RemoteSignupState {
  final SendOtpEmailEntity sendOtp;

  const RemoteSignupSendOtpEmailDone(this.sendOtp);
}

class RemoteSignupSendOtpEmailError extends RemoteSignupState {
  const RemoteSignupSendOtpEmailError();
}
