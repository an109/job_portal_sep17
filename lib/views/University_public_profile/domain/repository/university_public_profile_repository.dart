
import '../entities/university_public_profile_entity.dart';

abstract class UniversityPublicProfileRepository {
  Future<UniversityPublicProfileEntity> getUniversityPublicProfile(int userId);
}