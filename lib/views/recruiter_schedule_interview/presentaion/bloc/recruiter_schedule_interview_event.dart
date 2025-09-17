import '../../domain/entities/recruiter_schedule_interview_entity.dart';

abstract class RecruiterScheduleInterviewEvent {}

class ScheduleInterviewRequested extends RecruiterScheduleInterviewEvent {
  final int applicantId;
  final RecruiterScheduleInterviewEntity entity;

  ScheduleInterviewRequested({
    required this.applicantId,
    required this.entity,
  });
}