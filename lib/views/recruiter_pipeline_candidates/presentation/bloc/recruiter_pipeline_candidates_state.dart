import 'package:equatable/equatable.dart';
import '../../data/models/recruiter_pipeline_candidates_response_model.dart';

abstract class RecruiterPipelineCandidatesState extends Equatable {
  const RecruiterPipelineCandidatesState();

  @override
  List<Object> get props => [];
}

class RecruiterPipelineCandidatesInitial extends RecruiterPipelineCandidatesState {}

class RecruiterPipelineCandidatesLoading extends RecruiterPipelineCandidatesState {}

class RecruiterPipelineCandidatesSuccess extends RecruiterPipelineCandidatesState {
  final PipelineCandidateResponseModel data;

  const RecruiterPipelineCandidatesSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class RecruiterPipelineCandidatesFailed extends RecruiterPipelineCandidatesState {
  final String error;

  const RecruiterPipelineCandidatesFailed(this.error);

  @override
  List<Object> get props => [error];
}