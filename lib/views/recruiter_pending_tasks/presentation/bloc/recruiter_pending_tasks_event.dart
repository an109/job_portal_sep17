import 'package:equatable/equatable.dart';

abstract class RecruiterPendingTasksEvent extends Equatable {
  const RecruiterPendingTasksEvent();

  @override
  List<Object> get props => [];
}

class FetchPendingTasks extends RecruiterPendingTasksEvent {}