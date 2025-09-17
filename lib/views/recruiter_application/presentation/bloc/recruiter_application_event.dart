import 'package:equatable/equatable.dart';

abstract class RecruiterApplicationEvent extends Equatable {
  const RecruiterApplicationEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecruiterApplications extends RecruiterApplicationEvent {
  final int jobPostId;

  const FetchRecruiterApplications(this.jobPostId);

  @override
  List<Object?> get props => [jobPostId];
}