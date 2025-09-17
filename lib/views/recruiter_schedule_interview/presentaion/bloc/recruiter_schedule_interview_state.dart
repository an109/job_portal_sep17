import '../../data/models/recruiter_schedule_interview_response_model.dart';

abstract class RecruiterScheduleInterviewState {}

class RecruiterScheduleInterviewInitial extends RecruiterScheduleInterviewState {}

class RecruiterScheduleInterviewLoading extends RecruiterScheduleInterviewState {}

class RecruiterScheduleInterviewSuccess extends RecruiterScheduleInterviewState {
  final RecruiterScheduleInterviewResponseModel response;

  RecruiterScheduleInterviewSuccess(this.response);
}

class RecruiterScheduleInterviewFailed extends RecruiterScheduleInterviewState {
  final String error;

  RecruiterScheduleInterviewFailed(this.error);
}