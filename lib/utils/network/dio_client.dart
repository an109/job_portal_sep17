import 'package:dio/dio.dart';
import 'package:job_portal/injection_container.dart';
import 'package:job_portal/utils/storage/shared_preference.dart';

class DioClient {
  final Dio _dio;

  DioClient(String baseUrl)
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ) {
    // Add interceptor
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));

    // add more custom interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // can add bearer token here

        String token =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTksImVtYWlsIjoiYTgyOTEyNjYwMTJAZ21haWwuY29tIiwicm9sZSI6IlNUVURFTlQiLCJpYXQiOjE3NTY5NzY2MTQsImV4cCI6MTc2MjE2MDYxNH0.EbMTrFf5XcwBP7UjhexrkdpDsqccoL6LOBWc9HXGJqA";
        final _prefs = sl<PreferencesManager>();
        final storedToken = _prefs.getToken();
        if (storedToken != null && storedToken != '') {
          token = storedToken;
        }
        options.headers.addAll({'Authorization': 'Bearer $token'});
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // can add global error handling here
        return handler.next(e);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
    ));
  }

  Dio get instance => _dio;
}
