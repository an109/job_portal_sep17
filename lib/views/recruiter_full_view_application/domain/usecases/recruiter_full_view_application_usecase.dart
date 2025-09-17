import 'package:job_portal/utils/resourses/data_state.dart';
import '../entities/recruiter_full_view_application_entity.dart';
import '../repository/recruiter_full_view_application_repository.dart';

class GetApplicantDetailsUseCase {
  final RecruiterFullViewApplicationRepository repository;

  GetApplicantDetailsUseCase(this.repository);

  Future<DataState<FullApplicantEntity>> call(int jobId, int applicantId) {
    return repository.getFullApplicantDetails(jobId, applicantId);
  }
}