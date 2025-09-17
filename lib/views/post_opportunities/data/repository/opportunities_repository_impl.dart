import 'dart:developer' as developer show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/post_opportunities/data/data_sources/opportunities_api_service.dart';
import 'package:job_portal/views/post_opportunities/domain/entities/internship_metadata_entity.dart';
import 'package:job_portal/views/post_opportunities/domain/repository/opportunity_repository.dart';

class OpportunitiesRepositoryImpl extends OpportunityRepository {
  final OpportunitiesApiService _apiService;

  OpportunitiesRepositoryImpl(this._apiService);

  @override
  Future<DataState<InternshipMetadataEntity>> getOpportunityFormMetadata() async {
    try {
      final res = await _apiService.getOpportunityFormMetadata();
      if (res.response.statusCode == HttpStatus.ok || res.response.statusCode == HttpStatus.created) {
        developer.log('.checkk response in repository : ${res.data}');
        return DataSuccess(res.data);
      } else {
        developer.log('..checkk response in repository : ${res.data}');
        return DataFailed(DioException(
          error: res.response.statusMessage,
          response: res.response,
          type: DioExceptionType.badResponse,
          requestOptions: res.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<InternshipMetadataEntity>> createJobPost(
      Map<String, dynamic> params) async {
    try {
      final res = await _apiService.createJobPost(params);
      if (res.response.statusCode == HttpStatus.ok  || res.response.statusCode == HttpStatus.created) {
        developer.log('.checkk response in repository : ${res.data}');
        return DataSuccess(res.data);
      } else {
        developer.log('..checkk response in repository : ${res.data}');
        return DataFailed(DioException(
          error: res.response.statusMessage,
          response: res.response,
          type: DioExceptionType.badResponse,
          requestOptions: res.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      developer.log('...checkk response in repository : ${e.error}');
      return DataFailed(e);
    }
  }

  //  Added: Fetch master data (used for dropdowns, forms, etc.)
  @override
  Future<DataState<dynamic>> getMasterAllData() async {
    try {
      final res = await _apiService.getMasterAllData();
      if (res.response.statusCode == HttpStatus.ok  || res.response.statusCode == HttpStatus.created) {
        developer.log(' Master data fetched successfully: ${res.data}');
        return DataSuccess(res.data);
      } else {
        developer.log(' Master data failed: ${res.response.statusMessage}');
        return DataFailed(DioException(
          error: res.response.statusMessage,
          response: res.response,
          type: DioExceptionType.badResponse,
          requestOptions: res.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      developer.log('🚨 DioException in getMasterAllData: ${e.message}');
      return DataFailed(e);
    }
  }
}