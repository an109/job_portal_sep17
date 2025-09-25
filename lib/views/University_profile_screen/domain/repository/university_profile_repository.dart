// university_profile_repository.dart
import 'package:dio/dio.dart';
import '../../../../utils/resourses/data_state.dart';
import '../entities/university_profile_entity.dart';

abstract class UniversityProfileRepository {
  Future<DataState<UniversityProfileEntity>> getUniversityProfile();
  Future<DataState<void>> updateUniversityProfile(UniversityProfileEntity entity);
}