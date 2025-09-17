import 'package:equatable/equatable.dart';
import '../../../domain/entities/recruiter_job_post_entity.dart';

abstract class RecruiterJobPostState extends Equatable {
  const RecruiterJobPostState();
  @override
  List<Object?> get props => [];
}

class RecruiterJobPostInitial extends RecruiterJobPostState {}

class RecruiterJobPostLoading extends RecruiterJobPostState {}

class RecruiterJobPostLoaded extends RecruiterJobPostState {
  final List<RecruiterJobPostEntity> jobPosts;

  const RecruiterJobPostLoaded.all(this.jobPosts);

  @override
  List<Object?> get props => [jobPosts];
}

class RecruiterJobPostError extends RecruiterJobPostState {
  final String message;

  const RecruiterJobPostError(this.message);

  @override
  List<Object?> get props => [message];
}