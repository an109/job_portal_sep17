import 'package:flutter/material.dart';

@immutable
abstract class UserAuthEvent {}

class SendOtpToMobileEvent extends UserAuthEvent {
  final String phoneNumber;
  SendOtpToMobileEvent({required this.phoneNumber});
}

class VerifyPhoneNumberEvent extends UserAuthEvent {
  final String phoneNumber;
  final String otp;

  VerifyPhoneNumberEvent({required this.phoneNumber, required this.otp});
}