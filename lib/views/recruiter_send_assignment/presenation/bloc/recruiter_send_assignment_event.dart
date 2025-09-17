import '../../domain/entities/recruiter_send_assignment_entity.dart';

abstract class RecruiterSendAssignmentEvent {}

class SendAssignmentRequested extends RecruiterSendAssignmentEvent {
  final int applicantId;
  final RecruiterSendAssignmentEntity entity;

  SendAssignmentRequested({
    required this.applicantId,
    required this.entity,
  });
}