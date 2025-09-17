import 'package:equatable/equatable.dart';

abstract class RecruiterPipelineCandidatesEvent extends Equatable {
  const RecruiterPipelineCandidatesEvent();

  @override
  List<Object> get props => [];
}

class FetchPipelineCandidates extends RecruiterPipelineCandidatesEvent {}