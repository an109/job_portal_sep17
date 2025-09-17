import 'dart:developer' as develop show log;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/user_profile/data/data_sources/profile_api_service.dart';
import 'package:job_portal/views/user_profile/data/models/public_profile_model.dart';
import 'package:job_portal/views/user_profile/data/models/user_details_response.dart';
import 'package:job_portal/views/user_profile/domain/entities/all_job_applications_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/followers_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/public_profile_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/raise_ticket_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/terms_and_conditions_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_email_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_profile_entity.dart';
import 'package:job_portal/views/user_profile/domain/entities/user_details_entity.dart';
import 'package:job_portal/views/user_profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileApiService _apiService;

  ProfileRepositoryImpl(this._apiService);

  @override
  Future<DataState<UserProfileModel>> getPublicProfile(String id) async {
    try {
      final response = await _apiService.getPublicProfile(id);

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
  Future<DataState<UserDetailEntity>> getUserDetails(String id) async {
    try {
      final response = await _apiService.getUserDetails(id);

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
  Future<DataState<TermsAndConditionEntity>> getTermsAndConditions() async {
    try {
      final response = await _apiService.getTermsAndConditions();

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
  Future<DataState<UpdateUserProfileEntity>> updateUserDetailsById(
      String id, Map<String, dynamic> params) async {
    try {
      final response = await _apiService.updateUserDetailsById(id, params);

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
  Future<DataState<UpdateUserEmailEntity>> changeUserEmail(
      Map<String, dynamic> params) async {
    try {
      final response = await _apiService.changeUserEmail(params);

      // 👇 ADD THESE LINES — COPY PASTE EXACTLY
      develop.log('>>> CHANGE EMAIL API RESPONSE STATUS: ${response.response.statusCode}');
      develop.log('>>> CHANGE EMAIL API RESPONSE DATA: ${response.data}');
      develop.log('>>> CHANGE EMAIL API RESPONSE BODY: ${response.response.data}');

      if (response.response.statusCode == HttpStatus.ok && response.data != null) {
        return DataSuccess(response.data);
      } else {
        develop.log('>>> CHANGE EMAIL ERROR: ${response.response.statusMessage}');
        return DataFailed(
          DioException(
            error: response.response.statusMessage ?? 'Unknown error',
            requestOptions: response.response.requestOptions,
            response: response.response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } on DioException catch (e) {
      develop.log('>>> DIO EXCEPTION: $e');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<AllJobApplicationsEntity>> getJobApplications() async {
    try {
      final response = await _apiService.getJobApplications();

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
  Future<DataState<FollowersEntity>> getFollowers(String id) async {
    try {
      final response = await _apiService.getFollowers(id);

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
  Future<DataState<FollowingEntity>> getFollowings(String id) async {
    try {
      final response = await _apiService.getFollowing(id);

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
  Future<DataState<RaiseTicketResponseEntity>> raiseTicket(
      Map<String, dynamic> params) async {
    try {
      final response = await _apiService.raiseTicket(params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created) {
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
