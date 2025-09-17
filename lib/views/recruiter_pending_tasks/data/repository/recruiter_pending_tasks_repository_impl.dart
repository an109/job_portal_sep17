import 'package:job_portal/views/recruiter_pending_tasks/domain/repository/recruiter_pending_tasks_repository.dart';
import 'package:job_portal/views/recruiter_pending_tasks/data/data_source/recruiter_pending_tasks_api_service.dart';
import '../models/recruiter_pending_tasks_response_model.dart';

class RecruiterPendingTasksRepositoryImpl implements RecruiterPendingTasksRepository {
  final RecruiterPendingTasksApiService _apiService;

  RecruiterPendingTasksRepositoryImpl(this._apiService);

  @override
  Future<PendingTasksResponseModel> getViewPendingTask() async {
    final response = await _apiService.getViewPendingTask();
    return response;
  }
}