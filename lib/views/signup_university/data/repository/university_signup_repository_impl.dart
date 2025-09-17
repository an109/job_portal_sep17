import 'dart:developer' as developer show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/signup_university/data/data_source/university_signup_api_service.dart';
import 'package:job_portal/views/signup_university/domain/repository/university_signup_repository.dart';

class UniversitySignupRepositoryImpl extends UniversitySignupRepository {
  final UniversitySignupApiService _apiService;

  UniversitySignupRepositoryImpl(this._apiService);

  @override
  Future<DataState<CourseListEntity>> getCourses() async {
    try {
      final res = await _apiService.getCourses();
      if (res.response.statusCode == HttpStatus.ok) {
        developer.log('.checkk response in repository : ${res.data}');
        return DataSuccess(res.data);
      } else {
        developer.log('..checkk response in repository : ${res.data}');
        return DataFailed(DioException(
            error: res.response.statusMessage,
            response: res.response,
            type: DioExceptionType.badResponse,
            requestOptions: res.response.requestOptions));
      }
    } on DioException catch (e) {
      final error = e.type;
      developer.log('....checkk  : $error');
      return DataFailed(e);
    }
  }
}
