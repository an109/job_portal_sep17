import 'package:equatable/equatable.dart';

abstract class JobApplicationsEvent extends Equatable {
  const JobApplicationsEvent();
}

class LoadAllApplications extends JobApplicationsEvent {
  const LoadAllApplications();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
