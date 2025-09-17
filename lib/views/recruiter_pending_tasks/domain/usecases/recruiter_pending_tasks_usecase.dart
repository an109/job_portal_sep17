import 'package:job_portal/views/recruiter_pending_tasks/domain/repository/recruiter_pending_tasks_repository.dart';
import '../../data/models/recruiter_pending_tasks_response_model.dart';

class RecruiterPendingTasksUseCase {
  final RecruiterPendingTasksRepository _repository;

  RecruiterPendingTasksUseCase(this._repository);

  Future<PendingTasksResponseModel> call() async {
    return await _repository.getViewPendingTask();
  }
}