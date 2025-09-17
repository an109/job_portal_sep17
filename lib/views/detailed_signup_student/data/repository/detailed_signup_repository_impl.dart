import 'dart:convert';
import 'dart:developer' as developer show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/detailed_signup_student/data/data_source/detailed_api_service.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/basic_user_data_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/colleges_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/job_roles_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/skill_submission_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/specialization_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/submit_detailed_user_profile.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';
import 'package:job_portal/views/detailed_signup_student/domain/repository/detailed_signup_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailedSignupRepositoryImpl extends DetailedSignupRepository {
  final DetailedApiService _apiService;

  DetailedSignupRepositoryImpl(this._apiService);

  @override
  Future<DataState<dynamic>> getMasterAllData() async {
    try {
      final response = await _apiService.getMasterAllData();
      if (response.response.statusCode == 200) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(DioException(
          requestOptions: response.response.requestOptions,
          type: DioExceptionType.badResponse,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<BasicUserInfoResponse>> getBasicUserInfo(
      Map<String, dynamic> emailMap) async {
    try {
      final res = await _apiService.getBasicUserInfo(emailMap);
      if (res.response.statusCode == HttpStatus.ok) {
        developer.log('.checkk response in repository : ${res.data.message}');
        return DataSuccess(res.data);
      } else {
        developer.log('..checkk response in repository : ${res.data.message}');
        return DataFailed(DioException(
            error: res.response.statusMessage,
            response: res.response,
            type: DioExceptionType.badResponse,
            requestOptions: res.response.requestOptions));
      }
    } on DioException catch (e) {
      final error = e.type;
      developer.log('....checkk  : ${error}');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CollegeListEntity>> getColleges(
      Map<String, dynamic> emailMap) async {
    try {
      final res = await _apiService.getColleges(emailMap);
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

  @override
  Future<DataState<List<SpecializationEntity>>> getSpecialization(String course_id) async {
    try {
      final res = await _apiService.getSpecialization(course_id);
      for (var model in res.data.data) {
        developer.log('➡️ Specialization Model: $model');
      }
      developer.log('🔍 Raw API Response: ${res.data}');
      developer.log('📄 Specialization count: ${res.data.data.length}');

      if (res.response.statusCode == HttpStatus.ok && res.data.success) {
        final List<SpecializationEntity> specializations = res.data.data
            .map((model) {
          developer.log('⚡ Converting model: ${model.name}');
          return model.toEntity();
        })
            .toList();

        developer.log('✅ Specializations converted: ${specializations.length}');
        return DataSuccess(specializations);
      } else {
        developer.log('❌ API failed: ${res.data.message}');
        return DataFailed(DioException(
          error: res.data.message,
          type: DioExceptionType.badResponse,
          requestOptions: res.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      developer.log('🚨 Exception in getSpecialization: $e');
      return DataFailed(e);
    }
  }

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

  @override
  Future<DataState<LocationListEntity>> getLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedMasterData = prefs.getString('master_api_all_data');

      if (cachedMasterData != null) {
        final Map<String, dynamic> masterData = jsonDecode(cachedMasterData);

        if (masterData.containsKey('data') && masterData['data'].containsKey('locations')) {
          final List<dynamic> locationJsonList = masterData['data']['locations'];
          final List<LocationEntity> locations = locationJsonList
              .map((e) => LocationEntity(id: e['id'], name: e['name']))
              .toList();

          final locationListEntity = LocationListEntity(
            success: true,
            locations: locations,
            message: 'Locations loaded from cache',
          );

          return DataSuccess(locationListEntity);
        }
      }

      // Fallback to API if cache missing
      final response = await _apiService.getLocations();
      if (response.response.statusCode == 200) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(DioException(
          requestOptions: response.response.requestOptions,
          type: DioExceptionType.badResponse,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    } catch (e) {
      developer.log('Error loading locations from cache: $e');
      return DataFailed(DioException(requestOptions: RequestOptions()));
    }
  }

  @override
  Future<DataState<JobRolesListResponse>> getJobRoles() async {
    try {
      final res = await _apiService.getJobRoles();
      developer.log('API Response: ${res.data}, Status: ${res.response.statusCode}');
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

  @override
  Future<DataState<SubmitDetailedUserProfile>> submitDetailedUserProfile(
      Map<String, dynamic> params,
      ) async {
    try {
      final res = await _apiService.submitDetailedUserProfile(params);

      // Accept OK, Created, Conflict
      if (res.response.statusCode == HttpStatus.ok ||
          res.response.statusCode == HttpStatus.created ||
          res.response.statusCode == HttpStatus.conflict) {
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
      developer.log('....checkk  : ${e.type}');

      // Special case: backend returned valid JSON but with bad status
      if (e.response != null && e.response!.data != null) {
        try {
          final data = SubmitDetailedUserProfile.fromJson(e.response!.data);
          developer.log('...Parsed response from error: $data');
          return DataSuccess(data);
        } catch (parseError) {
          developer.log('❌ Failed to parse error response: $parseError');
        }
      }

      return DataFailed(e);
    }
  }

}
