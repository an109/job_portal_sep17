import '../../../../utils/resourses/data_state.dart';
import '../entities/recruiter_application_entity.dart';
import '../repository/recruiter_application_repository.dart';

class RecruiterApplicationUseCase {
  final RecruiterApplicationRepository repository;

  RecruiterApplicationUseCase(this.repository);

  Future<DataState<List<RecruiterApplicationEntity>>> call(int jobPostId) {
    return repository.getApplications(jobPostId);
  }
}