import '../entities/university_public_profile_entity.dart';
import '../repository/university_public_profile_repository.dart';


class UniversityPublicProfileUseCase {
  final UniversityPublicProfileRepository repository;

  UniversityPublicProfileUseCase(this.repository);

  Future<UniversityPublicProfileEntity> call(int userId) async {
    return await repository.getUniversityPublicProfile(userId);
  }
}