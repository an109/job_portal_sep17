import '../../data/models/recruiter_upcoming_interviews_response_model.dart';

abstract class RecruiterUpcomingInterviewsRepository {
  Future<List<UpcomingInterviewResponseModel>> getUpcomingInterviews();
}