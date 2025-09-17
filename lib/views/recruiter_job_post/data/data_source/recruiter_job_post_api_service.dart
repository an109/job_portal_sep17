import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/recruiter_job_post_response_model.dart';

part 'recruiter_job_post_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterJobPostApiService {
  factory RecruiterJobPostApiService(Dio dio, {String? baseUrl}) = _RecruiterJobPostApiService;

  @GET("${Urls.totalJobPost}")
  Future<HttpResponse<RecruiterJobPostResponseModel>> getAllJobPosts();

  @GET(Urls.getAllApplicantsCount)
  Future<HttpResponse<ApplicantCountResponseModel>> getAllApplicantsCount(@Path("jobPostId") int jobPostId);

}