import '../../../../utils/resourses/data_state.dart';
import '../entities/recruiter_application_entity.dart';

abstract class RecruiterApplicationRepository {
  Future<DataState<List<RecruiterApplicationEntity>>> getApplications(int jobPostId);
}