import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UniversitySignupEvent extends Equatable {
  const UniversitySignupEvent();
}

class LoadCourses extends UniversitySignupEvent {
  const LoadCourses();

  @override
  List<Object?> get props => [];
}
