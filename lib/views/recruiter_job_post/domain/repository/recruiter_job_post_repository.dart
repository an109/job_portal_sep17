import 'package:job_portal/utils/resourses/data_state.dart';
import '../entities/recruiter_job_post_entity.dart';

abstract class RecruiterJobPostRepository {

  Future<DataState<List<RecruiterJobPostEntity>>> getAllJobPosts();

}