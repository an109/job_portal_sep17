import '../../../../utils/resourses/data_state.dart';
import '../../../../utils/usecase/usecases.dart';
import '../entities/recruiter_job_post_entity.dart';
import '../repository/recruiter_job_post_repository.dart';

class RecruiterJobPostsUseCase
    implements UseCase<DataState<List<RecruiterJobPostEntity>>, NoParams> {
  final RecruiterJobPostRepository repository;

  RecruiterJobPostsUseCase(this.repository);

  @override
  Future<DataState<List<RecruiterJobPostEntity>>> call({NoParams? params}) async {
    return await repository.getAllJobPosts();
  }
}

class NoParams {}