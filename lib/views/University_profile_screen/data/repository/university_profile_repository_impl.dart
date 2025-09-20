

import '../../domain/entities/university_profile_entity.dart';
import '../../domain/repository/university_profile_repository.dart';
import '../data_source/university_profile_api_service.dart';
import '../models/university_profile_response.dart';

class UniversityProfileRepositoryImpl implements UniversityProfileRepository {
  final UniversityProfileApiService _apiService;

  UniversityProfileRepositoryImpl(this._apiService);

  @override
  Future<void> updateUniversityProfile(UniversityProfileEntity entity) async {
    final model = UniversityProfileResponse.fromJson(entity.toJson());
    await _apiService.updateUniversityProfile(model);
  }
}