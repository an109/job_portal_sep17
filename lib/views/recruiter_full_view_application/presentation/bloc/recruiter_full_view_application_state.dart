import '../../domain/entities/recruiter_full_view_application_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RecruiterFullViewApplicationState extends Equatable {
  const RecruiterFullViewApplicationState();

  @override
  List<Object?> get props => [];
}

class RecruiterFullViewApplicationInitial extends RecruiterFullViewApplicationState {}

class RecruiterFullViewApplicationLoading extends RecruiterFullViewApplicationState {}


class RecruiterFullViewApplicationSuccess extends RecruiterFullViewApplicationState {
  final FullApplicantEntity applicant;
  const RecruiterFullViewApplicationSuccess(this.applicant);

  @override
  List<Object?> get props => [applicant];
}

class RecruiterFullViewApplicationFailed extends RecruiterFullViewApplicationState {
  final String message;
  const RecruiterFullViewApplicationFailed(this.message);

  @override
  List<Object?> get props => [message];
}