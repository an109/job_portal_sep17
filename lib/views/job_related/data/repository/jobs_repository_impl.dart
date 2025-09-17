import 'dart:developer' as develop show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/job_related/data/data_source/job_screens_api_service.dart';
import 'package:job_portal/views/job_related/domain/entities/all_jobs_entity.dart';
import 'package:job_portal/views/job_related/domain/entities/job_apply_entity.dart';
import 'package:job_portal/views/job_related/domain/entities/job_details_entity.dart';
import 'package:job_portal/views/job_related/domain/repository/jobs_repository.dart';

class JobsRepositoryImpl extends JobsRepository {
  final JobScreensApiService _apiService;

  JobsRepositoryImpl(this._apiService);

  @override
  Future<DataState<List<AllJobsEntity>>> getOpportunities() async {
    try {
      final response = await _apiService.getOpportunities();

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(
          DioException(
              error: response.response.statusMessage,
              requestOptions: response.response.requestOptions,
              response: response.response,
              type: DioExceptionType.badResponse),
        );
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<JobDetailsEntity>> getJobDetails(String job_id) async {
    try {
      final response = await _apiService.getJobDetails(job_id);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(
          DioException(
              error: response.response.statusMessage,
              requestOptions: response.response.requestOptions,
              response: response.response,
              type: DioExceptionType.badResponse),
        );
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<JobApplyEntity>> applyForJob(
      String job_id, Map<String, dynamic> params) async {
    try {
      final response = await _apiService.applyForJob(job_id, params);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(
          DioException(
              error: response.response.statusMessage,
              requestOptions: response.response.requestOptions,
              response: response.response,
              type: DioExceptionType.badResponse),
        );
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
      return DataFailed(e);
    }
  }
}
