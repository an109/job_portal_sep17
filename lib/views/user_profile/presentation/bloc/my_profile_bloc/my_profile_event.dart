import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();
}

class PickCertificate extends MyProfileEvent {
  const PickCertificate();

  @override
  List<Object?> get props => [];
}

class LoadMyProfileDetails extends MyProfileEvent {
  final String id;
  const LoadMyProfileDetails(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class LoadUpdateProfile extends MyProfileEvent {
  final String id;
  final Map<String, dynamic> params;

  const LoadUpdateProfile(this.id, this.params);

  @override
  // TODO: implement props
  List<Object?> get props => [id, params];
}
