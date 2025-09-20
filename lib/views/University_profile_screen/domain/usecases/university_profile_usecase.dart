import '../entities/university_profile_entity.dart';
import '../repository/university_profile_repository.dart';

class UpdateUniversityProfileUseCase {
  final UniversityProfileRepository repository;

  UpdateUniversityProfileUseCase(this.repository);

  Future<void> call(UniversityProfileEntity entity) async {
    return await repository.updateUniversityProfile(entity);
  }
}