import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:job_portal/views/job_related/domain/entities/job_apply_entity.dart';

@immutable
abstract class JobApplyState extends Equatable {
  const JobApplyState();

  @override
  List<Object?> get props => [];
}

class JobApplyInitial extends JobApplyState {
  const JobApplyInitial();
}

class JobApplyLoading extends JobApplyState {
  const JobApplyLoading();
}

class JobApplyLoaded extends JobApplyState {
  final JobApplyEntity jobApplyEntity;

  const JobApplyLoaded(this.jobApplyEntity);
}

class JobApplyError extends JobApplyState {
  const JobApplyError();
}
