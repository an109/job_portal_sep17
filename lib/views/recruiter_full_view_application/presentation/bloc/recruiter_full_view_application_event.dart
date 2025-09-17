import 'package:equatable/equatable.dart';

abstract class RecruiterFullViewApplicationEvent extends Equatable {
  const RecruiterFullViewApplicationEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecruiterFullViewApplications extends RecruiterFullViewApplicationEvent {
  final int jobId;
  final int applicantId;

  const FetchRecruiterFullViewApplications(this.jobId, this.applicantId);

  @override
  List<Object?> get props => [jobId, applicantId];
}


