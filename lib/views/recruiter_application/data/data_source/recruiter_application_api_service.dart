import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/recruiter_application_response_model.dart';

part 'recruiter_application_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterApplicationApiService {
  factory RecruiterApplicationApiService(Dio dio, {String? baseUrl}) = _RecruiterApplicationApiService;

  @GET("jobpost/{jobPostId}/allapplicant")
  Future<RecruiterApplicationResponseModel> getApplications(
      @Path("jobPostId") int jobPostId,
      );

}