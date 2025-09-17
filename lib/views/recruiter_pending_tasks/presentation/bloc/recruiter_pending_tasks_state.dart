import 'package:equatable/equatable.dart';
import '../../data/models/recruiter_pending_tasks_response_model.dart';

abstract class RecruiterPendingTasksState extends Equatable {
  const RecruiterPendingTasksState();

  @override
  List<Object> get props => [];
}

class RecruiterPendingTasksInitial extends RecruiterPendingTasksState {}

class RecruiterPendingTasksLoading extends RecruiterPendingTasksState {}

class RecruiterPendingTasksSuccess extends RecruiterPendingTasksState {
  final PendingTasksResponseModel data;

  const RecruiterPendingTasksSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class RecruiterPendingTasksFailed extends RecruiterPendingTasksState {
  final String error;

  const RecruiterPendingTasksFailed(this.error);

  @override
  List<Object> get props => [error];
}