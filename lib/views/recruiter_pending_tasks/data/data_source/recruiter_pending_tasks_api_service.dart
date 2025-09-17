import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../utils/constants/urls.dart';
import '../models/recruiter_pending_tasks_response_model.dart';

part 'recruiter_pending_tasks_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterPendingTasksApiService {
  factory RecruiterPendingTasksApiService(Dio dio, {String? baseUrl}) = _RecruiterPendingTasksApiService;

  @GET(Urls.getViewPendingTask)
  Future<PendingTasksResponseModel> getViewPendingTask();
}