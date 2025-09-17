import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RemoteLoginEvent extends Equatable {
  const RemoteLoginEvent();
}

class RemoteLoginData extends RemoteLoginEvent {
  final Map<String, dynamic> loginMap;

  const RemoteLoginData(this.loginMap);

  @override
  List<Object?> get props => [loginMap];
}

class RemoteLoginSentOtpData extends RemoteLoginEvent {
  final Map<String, dynamic> emailMap;

  const RemoteLoginSentOtpData(this.emailMap);

  @override
  List<Object?> get props => [emailMap];
}

class RemoteLoginVerifyOtpData extends RemoteLoginEvent {
  final Map<String, dynamic> emailOtpMap;

  const RemoteLoginVerifyOtpData(this.emailOtpMap);

  @override
  List<Object?> get props => [emailOtpMap];
}
