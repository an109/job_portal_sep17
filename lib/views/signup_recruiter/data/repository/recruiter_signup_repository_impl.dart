import 'dart:developer' as developer show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/signup_recruiter/data/data_source/recruiter_signup_api_service.dart';
import 'package:job_portal/views/signup_recruiter/data/models/recruiter_signup_response.dart';
import 'package:job_portal/views/signup_recruiter/domain/entities/sigup_user_entity.dart';
import 'package:job_portal/views/signup_recruiter/domain/repository/recruiter_signup_repository.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

class RecruiterSignupRepositoryImpl extends RecruiterSignupRepository {
  final RecruiterSignupApiService _apiService;

  RecruiterSignupRepositoryImpl(this._apiService);

  @override
  Future<DataState<SignUpUserEntity>> registerUser(
      Map<String, dynamic> registerationMap) async {
    developer.log('hey');
    try {
      final res = await _apiService.registerUser(registerationMap);
      // int? statusCode = res.response.statusCode;
      if (res.response.statusCode == HttpStatus.ok ||
          res.response.statusCode == HttpStatus.created ||
          res.response.statusCode == HttpStatus.conflict) {
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
      // developer.log('....checkk  : ${error}');
      if (error == DioExceptionType.badResponse) {
        developer.log('...checkk response in repository : ${e.response}');
        final responseData = SignUpRecruiterResponse.fromJson(e.response!.data);
        // return DataSuccess(e.response!.data);
        return DataSuccess(responseData);
      }
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<SendOtpEmailEntity>> sendOtpEmail(
      Map<String, dynamic> emailMap) async {
    try {
      final response = await _apiService.sendOtpEmail(emailMap);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(DioException(
            error: response.response.statusMessage,
            response: response.response,
            type: DioExceptionType.badResponse,
            requestOptions: response.response.requestOptions));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<VerifyOtpEntity>> verifyOtpResponse(
      Map<String, dynamic> emailOtpMap) async {
    try {
      final response = await _apiService.verifyOtpEmail(emailOtpMap);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(DioException(
            error: response.response.statusMessage,
            response: response.response,
            type: DioExceptionType.badResponse,
            requestOptions: response.response.requestOptions));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
