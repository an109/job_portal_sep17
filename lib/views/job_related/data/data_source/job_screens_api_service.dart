import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/job_related/data/models/all_jobs_response.dart';
import 'package:job_portal/views/job_related/data/models/job_apply_model.dart';
import 'package:job_portal/views/job_related/data/models/job_details_reponse.dart';
import 'package:job_portal/views/job_related/domain/entities/job_apply_entity.dart';
import 'package:retrofit/retrofit.dart';

part 'job_screens_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class JobScreensApiService {
  factory JobScreensApiService(Dio dio, {String? baseUrl}) =
      _JobScreensApiService;

  @GET(Urls.opportunities)
  Future<HttpResponse<AllJobsResponse>> getOpportunities();

  @GET('${Urls.jobDetails}{job_id}')
  Future<HttpResponse<JobDetailsResponseModel>> getJobDetails(
      @Path() String job_id);

  @POST(Urls.applyForJob)
  Future<HttpResponse<JobApplyModel>> applyForJob(
      @Path() String job_id, @Body() Map<String, dynamic> params);
}
