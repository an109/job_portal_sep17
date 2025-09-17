import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../utils/constants/urls.dart';
import '../models/recruiter_upcoming_interviews_response_model.dart';

part 'recruiter_upcoming_interviews_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterUpcomingInterviewsApiService {
  factory RecruiterUpcomingInterviewsApiService(Dio dio, {String? baseUrl}) = _RecruiterUpcomingInterviewsApiService;

  @GET(Urls.getUpcomingInterviews)
  Future<List<UpcomingInterviewResponseModel>> getUpcomingInterviews();
}