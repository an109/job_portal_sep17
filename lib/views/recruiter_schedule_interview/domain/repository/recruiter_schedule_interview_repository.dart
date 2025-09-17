import '../../data/models/recruiter_schedule_interview_response_model.dart';
import '../entities/recruiter_schedule_interview_entity.dart';

abstract class RecruiterScheduleInterviewRepository {
  Future<RecruiterScheduleInterviewResponseModel> scheduleInterview({
    required int applicantId,
    required RecruiterScheduleInterviewEntity entity,
  });
}