import '../entities/university_profile_entity.dart';

abstract class UniversityProfileRepository {
  Future<void> updateUniversityProfile(UniversityProfileEntity entity);
}