import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UploadResumeState extends Equatable {
  const UploadResumeState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UploadResumeInitial extends UploadResumeState {
  const UploadResumeInitial();
}

class PickResumeLoading extends UploadResumeState {
  const PickResumeLoading();
}

class PickResumeLoaded extends UploadResumeState {
  final FilePickerResult file;

  const PickResumeLoaded(this.file);
}

class PickResumeNoFilePicked extends UploadResumeState {
  const PickResumeNoFilePicked();
}

class PickResumeError extends UploadResumeState {
  const PickResumeError();
}
