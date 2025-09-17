import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:job_portal/views/job_related/domain/entities/job_apply_entity.dart';
import 'package:job_portal/views/job_related/domain/entities/job_details_entity.dart';

@immutable
abstract class JobDetailsState extends Equatable {
  const JobDetailsState();

  @override
  List<Object?> get props => [];
}

class JobDetailsInitial extends JobDetailsState {
  const JobDetailsInitial();
}

class JobDetailsLoading extends JobDetailsState {
  const JobDetailsLoading();
}

class JobDetailsLoaded extends JobDetailsState {
  final JobDetailsEntity jobDetailsEntity;

  const JobDetailsLoaded(this.jobDetailsEntity);
}

class JobDetailsError extends JobDetailsState {
  const JobDetailsError();
}

// class JobApplyLoading extends JobDetailsState {
//   const JobApplyLoading();
// }

// class JobApplyLoaded extends JobDetailsState {
//   final JobApplyEntity jobApplyEntity;

//   const JobApplyLoaded(this.jobApplyEntity);
// }

// class JobApplyError extends JobDetailsState {
//   const JobApplyError();
// }
