import 'package:equatable/equatable.dart';

abstract class RecruiterDashboardState extends Equatable {
  const RecruiterDashboardState();

  @override
  List<Object> get props => [];
}

class RecruiterDashboardInitial extends RecruiterDashboardState {}

class RecruiterDashboardLoading extends RecruiterDashboardState {}

class RecruiterDashboardLoaded extends RecruiterDashboardState {
  final int totalCount;
  final int pendingTasksCount;
  final int upcomingInterviewsCount;

  const RecruiterDashboardLoaded({
    required this.totalCount,
    this.pendingTasksCount = 0,
    this.upcomingInterviewsCount = 0,
  });

  @override
  List<Object> get props => [
    totalCount,
    pendingTasksCount,
    upcomingInterviewsCount,
  ];
}

class RecruiterDashboardError extends RecruiterDashboardState {
  final String message;

  const RecruiterDashboardError(this.message);

  @override
  List<Object> get props => [message];
}