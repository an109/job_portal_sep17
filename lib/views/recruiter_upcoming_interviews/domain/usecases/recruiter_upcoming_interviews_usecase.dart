import 'package:job_portal/views/recruiter_upcoming_interviews/domain/repository/recruiter_upcoming_interviews_repository.dart';

import '../../data/models/recruiter_upcoming_interviews_response_model.dart';

class RecruiterUpcomingInterviewsUseCase {
  final RecruiterUpcomingInterviewsRepository _repository;

  RecruiterUpcomingInterviewsUseCase(this._repository);

  Future<List<UpcomingInterviewResponseModel>> call() async {
    return await _repository.getUpcomingInterviews();
  }
}