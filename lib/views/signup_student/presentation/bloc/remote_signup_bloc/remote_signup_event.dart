import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class RemoteSignupEvent extends Equatable {
  const RemoteSignupEvent();
}

class RemoteSignupInitialize extends RemoteSignupEvent {
  const RemoteSignupInitialize();

  @override
  List<Object?> get props => [];
}

class RemoteSignupData extends RemoteSignupEvent {
  final Map<String, dynamic> registerationMap;

  const RemoteSignupData(this.registerationMap);

  @override
  List<Object> get props => [registerationMap];
}

class RemoteLogOut extends RemoteSignupEvent {
  const RemoteLogOut();

  @override
  List<Object?> get props => [];
}

class RemoteSingupSendOtpEmail extends RemoteSignupEvent {
  final Map<String, dynamic> emailMap;

  const RemoteSingupSendOtpEmail(this.emailMap);

  @override
  List<Object?> get props => [emailMap];
}
