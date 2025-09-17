import 'package:job_portal/utils/resourses/data_state.dart';
import '../entities/recruiter_full_view_application_entity.dart';

abstract class RecruiterFullViewApplicationRepository {
  Future<DataState<FullApplicantEntity>> getFullApplicantDetails(int jobId, int applicantId);
}