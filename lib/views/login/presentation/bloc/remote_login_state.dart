import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:job_portal/views/login/data/models/login_user_response.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

@immutable
abstract class RemoteLoginState extends Equatable {
  const RemoteLoginState();

  @override
  List<Object?> get props => [];
}

class RemoteLoginInitialize extends RemoteLoginState {
  const RemoteLoginInitialize();
}

class RemoteLoginLoading extends RemoteLoginState {
  const RemoteLoginLoading();
}

class RemoteLoginLoaded extends RemoteLoginState {
  final LoginUserResponse loginUserResponse;

  const RemoteLoginLoaded(this.loginUserResponse);
}

class RemoteLoginError extends RemoteLoginState {
  const RemoteLoginError();
}

class RemoteLoginSendOtpLoading extends RemoteLoginState {
  const RemoteLoginSendOtpLoading();
}

class RemoteLoginSendOtpLoaded extends RemoteLoginState {
  final SendOtpEmailEntity sendOtpEmailEntity;

  const RemoteLoginSendOtpLoaded(this.sendOtpEmailEntity);
}

class RemoteLoginSendOtpError extends RemoteLoginState {
  const RemoteLoginSendOtpError();
}

class RemoteLoginVerifyOtpLoading extends RemoteLoginState {
  const RemoteLoginVerifyOtpLoading();
}

class RemoteLoginVerifyOtpLoaded extends RemoteLoginState {
  final VerifyOtpEntity verifyOtpEntity;

  const RemoteLoginVerifyOtpLoaded(this.verifyOtpEntity);
}

class RemoteLoginVerifyOtpError extends RemoteLoginState {
  const RemoteLoginVerifyOtpError();
}
