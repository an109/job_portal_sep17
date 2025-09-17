import 'package:equatable/equatable.dart';

abstract class RecruiterDashboardEvent extends Equatable {
  const RecruiterDashboardEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalJobCount extends RecruiterDashboardEvent {}