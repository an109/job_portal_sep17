import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UploadResumeEvent extends Equatable {
  const UploadResumeEvent();
}

class PickResume extends UploadResumeEvent {
  const PickResume();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ResetUploadResume extends UploadResumeEvent {
  const ResetUploadResume();

  @override
  List<Object?> get props => [];
}
