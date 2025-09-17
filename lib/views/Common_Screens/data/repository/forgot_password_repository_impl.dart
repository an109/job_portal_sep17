import 'dart:developer' as developer show log;

import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import '../../../../utils/constants/urls.dart';
import '../../domain/repository/forgot_password_repository.dart';
import '../data_source/forgot_password_api_service.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordApiService apiService;

  ForgotPasswordRepositoryImpl({required this.apiService});

  // @override
  // Future<DataState<String>> sendOtpToEmail(String email) async {
  //   try {
  //     final response = await apiService.sendForgotPasswordOtp({'email': email});
  //
  //     final data = response.response.data as Map<String, dynamic>?;
  //
  //     if (response.response.statusCode == 200 && data?['success'] == true) {
  //       final message = data?['message'] as String? ?? 'OTP sent successfully';
  //       return DataSuccess(message);
  //     } else {
  //       return DataFailed(
  //         DioException(
  //           requestOptions: response.response.requestOptions,
  //           response: response.response,
  //           type: DioExceptionType.badResponse,
  //         ),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     developer.log('ForgotPasswordRepo - sendOtp error: $e');
  //     return DataFailed(e);
  //   }
  // }

  @override
  Future<DataState<String>> sendOtpToEmail(String email) async {
    try {
      final response = await apiService.sendForgotPasswordOtp({'email': email});

      final data = response.response.data;
      if (response.response.statusCode == 200) {
        String message = 'OTP sent successfully';
        if (data is Map && data.containsKey('message')) {
          message = data['message'] as String;
        }
        return DataSuccess(message);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.response.requestOptions,
            response: response.response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } on DioException catch (e) {
      developer.log('ForgotPasswordRepo - sendOtp error: $e');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<String>> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final verifyResponse = await apiService.verifyOtp({'email': email, 'otp': otp});
      final verifyData = verifyResponse.response.data as Map<String, dynamic>?;

      final String? message = verifyData?['message'] as String?;
      if (verifyResponse.response.statusCode != 200 || message != 'email verification successful') {
        return DataFailed(
          DioException(
            requestOptions: verifyResponse.response.requestOptions,
            response: verifyResponse.response,
            type: DioExceptionType.badResponse,
            error: message ?? 'OTP verification failed',
          ),
        );
      }

      final String? token = verifyData?['token'] as String?;
      final int? userId = verifyData?['user']?['id'] as int?;

      if (token == null) {
        return DataFailed(
          DioException(
            error: 'Authentication token not received',
            requestOptions: verifyResponse.response.requestOptions,
            response: verifyResponse.response,
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final authDio = Dio(
        BaseOptions(
          baseUrl: Urls.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      authDio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

      final authApiService = ForgotPasswordApiService(authDio);
      final changeResponse = await authApiService.changePassword({
        'email': email,
        'newPassword': newPassword,
        'oldPassword': 'dummy_password', // Using dummy until new API
        'userId': userId,
      });

      if (changeResponse.response.statusCode == 200) {
        final changeData = changeResponse.response.data as Map<String, dynamic>?;
        final successMsg = changeData?['message'] as String? ?? 'Password changed successfully';
        return DataSuccess(successMsg);
      } else {
        final changeData = changeResponse.response.data as Map<String, dynamic>?;
        final errorMsg = changeData?['message'] as String? ?? 'Password change failed';
        return DataFailed(
          DioException(
            requestOptions: changeResponse.response.requestOptions,
            response: changeResponse.response,
            type: DioExceptionType.badResponse,
            error: errorMsg,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  // @override
  // Future<DataState<String>> verifyOtpAndResetPassword({
  //   required String email,
  //   required String otp,
  //   required String newPassword,
  // }) async {
  //   try {
  //
  //     final verifyResponse = await apiService.verifyOtp({
  //       'email': email,
  //       'otp': otp,
  //     });
  //
  //     final verifyData = verifyResponse.response.data as Map<String, dynamic>?;
  //
  //     if (verifyResponse.response.statusCode != 200 || verifyData?['success'] != true) {
  //       return DataFailed(
  //         DioException(
  //           requestOptions: verifyResponse.response.requestOptions,
  //           response: verifyResponse.response,
  //           type: DioExceptionType.badResponse,
  //           error: verifyData?['message'] ?? 'OTP verification failed',
  //         ),
  //       );
  //     }
  //
  //     final changeResponse = await apiService.changePassword({
  //       'email': email,
  //       'newPassword': newPassword,
  //     });
  //
  //     final changeData = changeResponse.response.data as Map<String, dynamic>?;
  //
  //     if (changeResponse.response.statusCode == 200 && changeData?['success'] == true) {
  //       final message = changeData?['message'] as String? ?? 'Password changed successfully';
  //       return DataSuccess(message);
  //     } else {
  //       return DataFailed(
  //         DioException(
  //           requestOptions: changeResponse.response.requestOptions,
  //           response: changeResponse.response,
  //           type: DioExceptionType.badResponse,
  //           error: changeData?['message'] ?? 'Password change failed',
  //         ),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     developer.log('ForgotPasswordRepo - verify & reset error: $e');
  //     return DataFailed(e);
  //   }
  // }
}