import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class VerifyOtpRecruiterEvent extends Equatable {
  const VerifyOtpRecruiterEvent();
}

class LoadVerifyRecruiterOtp extends VerifyOtpRecruiterEvent {
  final Map<String, dynamic> emailOtpMap;

  const LoadVerifyRecruiterOtp(this.emailOtpMap);

  @override
  List<Object?> get props => [emailOtpMap];
}
