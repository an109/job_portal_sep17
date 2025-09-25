// update_university_profile_use_case.dart
import 'package:dio/dio.dart';
import '../../../../utils/resourses/data_state.dart';
import '../entities/university_profile_entity.dart';
import '../repository/university_profile_repository.dart';

class UpdateUniversityProfileUseCase {
  final UniversityProfileRepository repository;

  UpdateUniversityProfileUseCase(this.repository);

  Future<DataState<void>> call(UniversityProfileEntity entity) async {
    return await repository.updateUniversityProfile(entity);
  }
}

class GetUniversityProfileUseCase {
  final UniversityProfileRepository repository;

  GetUniversityProfileUseCase(this.repository);

  Future<DataState<UniversityProfileEntity>> call() async {
    return await repository.getUniversityProfile();
  }
}