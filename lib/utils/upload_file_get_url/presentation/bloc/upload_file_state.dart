import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/utils/upload_file_get_url/domain/entities/upload_file_entity.dart';

@immutable
abstract class UploadFileState extends Equatable {
  const UploadFileState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UploadFileInitial extends UploadFileState {
  const UploadFileInitial();
}

class UploadFileLoading extends UploadFileState {
  const UploadFileLoading();
}

class UploadFileLoaded extends UploadFileState {
  final UploadFileEntity uploadFileEntity;

  const UploadFileLoaded(this.uploadFileEntity);
}

class UploadFileError extends UploadFileState {
  const UploadFileError();
}
