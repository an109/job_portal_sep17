import '../../data/models/recruiter_schedule_interview_response_model.dart';
import '../entities/recruiter_schedule_interview_entity.dart';
import '../repository/recruiter_schedule_interview_repository.dart';

class RecruiterScheduleInterviewUseCase {
  final RecruiterScheduleInterviewRepository _repository;

  RecruiterScheduleInterviewUseCase(this._repository);

  Future<RecruiterScheduleInterviewResponseModel> call({
    required int applicantId,
    required RecruiterScheduleInterviewEntity entity,
  }) async {
    return await _repository.scheduleInterview(
      applicantId: applicantId,
      entity: entity,
    );
  }
}