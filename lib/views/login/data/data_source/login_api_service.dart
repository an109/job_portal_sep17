import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/login/data/models/login_user_response.dart';
import 'package:job_portal/views/signup_student/data/models/send_otp_email_response.dart';
import 'package:job_portal/views/signup_student/data/models/verify_otp_response.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class LoginApiService {
  factory LoginApiService(Dio dio, {String? baseUrl}) = _LoginApiService;

  @POST(Urls.userLogin)
  Future<HttpResponse<LoginUserResponse>> userLogin(
      @Body() Map<String, dynamic> loginMap);

  @POST(Urls.sendOtpEmail)
  Future<HttpResponse<SendOtpEmailResponse>> sendOtpEmail(
      @Body() Map<String, dynamic> emailMap);

  @POST(Urls.verifyOtpEmail)
  Future<HttpResponse<VerifyOtpResponse>> verifyOtpEmail(
      @Body() Map<String, dynamic> emailOtpMap);
}
