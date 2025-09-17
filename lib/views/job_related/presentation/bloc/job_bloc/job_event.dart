import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class JobEvent extends Equatable {
  const JobEvent();
}

class LoadJobs extends JobEvent {
  const LoadJobs();

  @override
  List<Object?> get props => [];
}
