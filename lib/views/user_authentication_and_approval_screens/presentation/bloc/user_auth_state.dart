import 'package:flutter/material.dart';

@immutable
abstract class UserAuthState {}

class UserAuthInitial extends UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthSuccess extends UserAuthState {
  final String message;
  UserAuthSuccess(this.message);
}

class UserAuthFailure extends UserAuthState {
  final String message;
  UserAuthFailure(this.message);
}