import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UploadFileEvent extends Equatable {
  const UploadFileEvent();
}

class LoadUploadFile extends UploadFileEvent {
  final FormData data;
  final String uploadType;
  const LoadUploadFile(this.data, {this.uploadType = 'unknown'});

  @override
  List<Object?> get props => [data];
}
