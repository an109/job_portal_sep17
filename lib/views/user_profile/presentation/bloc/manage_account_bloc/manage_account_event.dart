import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ManageAccountEvent extends Equatable {
  const ManageAccountEvent();
}

class LoadChangeEmail extends ManageAccountEvent {
  final Map<String, dynamic> params;

  const LoadChangeEmail(this.params);

  @override
  // TODO: implement props
  List<Object?> get props => [params];
}

class LoadChangePassword extends ManageAccountEvent {
  final Map<String, dynamic> params;

  const LoadChangePassword(this.params);

  @override
  List<Object?> get props => [params];
}
