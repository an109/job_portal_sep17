import '../../data/models/recruiter_send_assignment_response_model.dart';

abstract class RecruiterSendAssignmentState {}

class RecruiterSendAssignmentInitial extends RecruiterSendAssignmentState {}

class RecruiterSendAssignmentLoading extends RecruiterSendAssignmentState {}

class RecruiterSendAssignmentSuccess extends RecruiterSendAssignmentState {
  final RecruiterSendAssignmentResponseModel response;

  RecruiterSendAssignmentSuccess(this.response);
}

class RecruiterSendAssignmentFailed extends RecruiterSendAssignmentState {
  final String error;

  RecruiterSendAssignmentFailed(this.error);
}