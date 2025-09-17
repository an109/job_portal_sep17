import '../../../../utils/resourses/data_state.dart';
import '../../../../utils/usecase/usecases.dart';
import '../entities/recruiter_dashboard_entity.dart';
import '../repository/recruiter_dashboard_repository.dart';

class RecruiterDashboardUsecase
    implements UseCase<DataState<RecruiterDashboardEntity>, Map<String, dynamic>> {
  final RecruiterDashboardRepository _repository;

  RecruiterDashboardUsecase(this._repository);

  @override
  Future<DataState<RecruiterDashboardEntity>> call({Map<String, dynamic>? params}) {

    return _repository.getDashboardStats();
  }
}