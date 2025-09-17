import 'package:equatable/equatable.dart';
import '../../data/models/recruiter_upcoming_interviews_response_model.dart';

abstract class RecruiterUpcomingInterviewsState extends Equatable {
  const RecruiterUpcomingInterviewsState();

  @override
  List<Object> get props => [];
}

class RecruiterUpcomingInterviewsInitial extends RecruiterUpcomingInterviewsState {}

class RecruiterUpcomingInterviewsLoading extends RecruiterUpcomingInterviewsState {}

class RecruiterUpcomingInterviewsSuccess extends RecruiterUpcomingInterviewsState {
  final List<UpcomingInterviewResponseModel> data;

  const RecruiterUpcomingInterviewsSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class RecruiterUpcomingInterviewsFailed extends RecruiterUpcomingInterviewsState {
  final String error;

  const RecruiterUpcomingInterviewsFailed(this.error);

  @override
  List<Object> get props => [error];
}