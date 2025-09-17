import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/detailed_signup_student/data/data_source/detailed_api_service.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/domian_all_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/skill_submission_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/subskill_response.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/detailed_signup_student/domain/repository/skill_repository.dart';

class SkillRepositoryImpl extends SkillRepository {
  final DetailedApiService apiService;
  SkillRepositoryImpl(this.apiService);

  @override
  Future<DataState<DomainListEntity>> getDomains() async {
    try {
      final response = await apiService.getDomains();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          DioException(
              requestOptions: response.response.requestOptions,
              type: DioExceptionType.badResponse,
              error: response.response.statusMessage,
              response: response.response),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<SkillListEntity>> getSubSkills(String domain) async {
    try {
      final response = await apiService.getSubSkills(domain);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(DioException(
            requestOptions: response.response.requestOptions,
            type: DioExceptionType.badResponse,
            error: response.response.statusMessage,
            response: response.response));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<SkillSubmitionResponse>> submitSkillsAndCertificates(
      Map<String, dynamic> data) async {
    try {
      final response = await apiService.submitSkillsAndCertificates(data);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(DioException(
            requestOptions: response.response.requestOptions,
            type: DioExceptionType.badResponse,
            error: response.response.statusMessage,
            response: response.response));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
