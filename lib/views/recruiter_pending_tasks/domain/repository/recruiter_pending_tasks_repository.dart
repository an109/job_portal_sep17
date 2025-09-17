import '../../data/models/recruiter_pending_tasks_response_model.dart';

abstract class RecruiterPendingTasksRepository {
  Future<PendingTasksResponseModel> getViewPendingTask();
}