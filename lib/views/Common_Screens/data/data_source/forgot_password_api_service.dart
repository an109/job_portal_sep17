import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:retrofit/retrofit.dart';

part 'forgot_password_api_service.g.dart';

@RestApi(baseUrl: "")
abstract class ForgotPasswordApiService {
  factory ForgotPasswordApiService(Dio dio) = _ForgotPasswordApiService;

  @POST(Urls.sendOtpEmail)
  Future<HttpResponse<void>> sendForgotPasswordOtp(
      @Body() Map<String, dynamic> body,
      );

  @POST(Urls.verifyOtpEmail)
  Future<HttpResponse<void>> verifyOtp(
      @Body() Map<String, dynamic> body,
      );

  @POST(Urls.changePassword)
  Future<HttpResponse<void>> changePassword(
      @Body() Map<String, dynamic> body,
      );
}