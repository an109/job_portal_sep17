import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class JobApplyEvent extends Equatable {
  const JobApplyEvent();
}

class LoadJobApply extends JobApplyEvent {
  final String job_id;
  // final Map<String, dynamic> params;

  const LoadJobApply(
    this.job_id,
  );

  @override
  List<Object?> get props => [job_id];
}
