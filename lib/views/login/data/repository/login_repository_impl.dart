import 'dart:developer' as develop show log;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/login/data/data_source/login_api_service.dart';
import 'package:job_portal/views/login/data/models/login_user_response.dart';
import 'package:job_portal/views/login/domain/repository/login_repository.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginApiService _apiService;

  LoginRepositoryImpl(this._apiService);

  @override
  Future<DataState<LoginUserResponse>> userLogin(
      Map<String, dynamic> loginMap) async {
    try {
      final response = await _apiService.userLogin(loginMap);
      if (response.response.statusCode == HttpStatus.ok) {
        develop.log('.ending up in repo success  : ${response.response.data}');
        return DataSuccess(response.data);
      } else {
        develop.log('.Ending up in repo error : ${response.response}');
        return DataFailed(DioException(
            error: response.response.statusMessage,
            requestOptions: response.response.requestOptions,
            response: response.response,
            type: DioExceptionType.badResponse));
      }
    } on DioException catch (e) {
      develop.log('Ending up in repo error : $e');
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
