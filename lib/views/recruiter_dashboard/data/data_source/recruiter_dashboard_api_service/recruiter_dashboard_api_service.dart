import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/Recruiter_Dashboard_Response_Model.dart';

part 'recruiter_dashboard_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterDashboardApiService {
  factory RecruiterDashboardApiService(Dio dio, {String? baseUrl}) =
  _RecruiterDashboardApiService;

  @GET(Urls.getDashboardStats)
  Future<RecruiterDashboardResponseModel> getDashboardStats();

  @GET(Urls.totalJobCount)
  Future<HttpResponse<RecruiterDashboardResponseModel>> getTotalJobCount();

}