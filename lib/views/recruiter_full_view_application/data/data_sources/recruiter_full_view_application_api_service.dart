import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/recruiter_full_view_appliaction_response_model.dart';
// import '../models/recruiter_full_view_application_response_model.dart';

part 'recruiter_full_view_application_api_service.g.dart'; // ← Will be generated

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterFullViewApplicationApiService {
  factory RecruiterFullViewApplicationApiService(Dio dio, {String? baseUrl}) = _RecruiterFullViewApplicationApiService;

  @GET(Urls.getFullApplicantDetails)
  Future<HttpResponse<RecruiterFullViewApplicationData>> getFullApplicantDetails(
      @Path("jobId") int jobId,
      @Path("applicantId") int applicantId,
      );
}