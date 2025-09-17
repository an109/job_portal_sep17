import 'package:equatable/equatable.dart';
import 'package:job_portal/views/user_profile/domain/entities/all_job_applications_entity.dart';

abstract class JobApplicationsState extends Equatable {
  const JobApplicationsState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class JobApplicationsInitial extends JobApplicationsState {
  const JobApplicationsInitial();
}

class JobApplicationsLoading extends JobApplicationsState {
  const JobApplicationsLoading();
}

class JobApplicationsLoaded extends JobApplicationsState {
  final AllJobApplicationsEntity applications;

  const JobApplicationsLoaded(this.applications);
}

class JobApplicationsError extends JobApplicationsState {
  const JobApplicationsError();
}
