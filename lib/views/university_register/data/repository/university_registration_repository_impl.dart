import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/entities/university_registration_entity.dart';
import '../../domain/repository/university_registration_repository.dart';
import '../data_source/university_registration_api_service.dart';

class UniversityRegistrationRepositoryImpl implements UniversityRegistrationRepository {
  final UniversityRegistrationApiService _apiService;

  UniversityRegistrationRepositoryImpl(this._apiService);

  @override
  Future<DataState<UniversityRegistrationEntity>> registerUniversity(UniversityRegistrationEntity entity) async {
    try {
      final response = await _apiService.registerUniversity(entity.toJson());

      if (response.success == true ) {
        final UniversityRegistrationEntity createdEntity = UniversityRegistrationEntity.fromJson(response.data);
        return DataSuccess(createdEntity);
      } else {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/universitydetail'),
          message: response.message ?? 'Registration failed',
        );
        return DataFailed(dioError);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    } catch (e) {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/universitydetail'),
        message: 'Unexpected error: $e',
      );
      return DataFailed(dioError);
    }
  }
}