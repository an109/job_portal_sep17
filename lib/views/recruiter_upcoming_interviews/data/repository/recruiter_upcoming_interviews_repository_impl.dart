import 'package:job_portal/views/recruiter_upcoming_interviews/domain/repository/recruiter_upcoming_interviews_repository.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/data/data_source/recruiter_upcoming_interviews_api_service.dart';

import '../models/recruiter_upcoming_interviews_response_model.dart';

class RecruiterUpcomingInterviewsRepositoryImpl implements RecruiterUpcomingInterviewsRepository {
  final RecruiterUpcomingInterviewsApiService _apiService;

  RecruiterUpcomingInterviewsRepositoryImpl(this._apiService);

  @override
  Future<List<UpcomingInterviewResponseModel>> getUpcomingInterviews() async {
    final response = await _apiService.getUpcomingInterviews();
    return response;
  }
}