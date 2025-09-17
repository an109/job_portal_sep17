import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();
}

class LoadVerifyOtp extends VerifyOtpEvent {
  final Map<String, dynamic> emailOtpMap;

  const LoadVerifyOtp(this.emailOtpMap);

  @override
  List<Object?> get props => [emailOtpMap];
}
