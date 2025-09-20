import '../../../../utils/resourses/data_state.dart';
import '../entities/university_registration_entity.dart';
import '../repository/university_registration_repository.dart';

class RegisterUniversityUseCase {
  final UniversityRegistrationRepository repository;

  RegisterUniversityUseCase(this.repository);

  Future<DataState<UniversityRegistrationEntity>> call(UniversityRegistrationEntity entity) {
    return repository.registerUniversity(entity);
  }
}