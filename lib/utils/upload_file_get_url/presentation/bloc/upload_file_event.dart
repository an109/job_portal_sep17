import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UploadFileEvent extends Equatable {
  const UploadFileEvent();
}

class LoadUploadFile extends UploadFileEvent {
  final FormData data;
  const LoadUploadFile(this.data);

  @override
  List<Object?> get props => [data];
}
