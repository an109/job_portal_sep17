import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/job_related/domain/entities/all_jobs_entity.dart';
import 'package:job_portal/views/post_opportunities/domain/entities/internship_metadata_entity.dart';

@immutable
abstract class JobState extends Equatable {
  const JobState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class JobInitial extends JobState {
  const JobInitial();
}

class JobsLoading extends JobState {
  const JobsLoading();
}

class JobsLoaded extends JobState {
  // put job list response entity here
  final List<AllJobsEntity> allJobsEntity;

  const JobsLoaded(this.allJobsEntity);
}

class JobsError extends JobState {
  const JobsError();
}
