import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/signup_recruiter/data/models/recruiter_signup_response.dart';
import 'package:job_portal/views/signup_student/data/models/send_otp_email_response.dart';
import 'package:job_portal/views/signup_student/data/models/verify_otp_response.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'recruiter_signup_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterSignupApiService {
  factory RecruiterSignupApiService(Dio dio, {String? baseUrl}) =
      _RecruiterSignupApiService;

  @POST(Urls.userRegisteration)
  Future<HttpResponse<SignUpRecruiterResponse>> registerUser(
      @Body() Map<String, dynamic> registerationMap);

  @POST(Urls.sendOtpEmail)
  Future<HttpResponse<SendOtpEmailResponse>> sendOtpEmail(
      @Body() Map<String, dynamic> emailMap);

  @POST(Urls.verifyOtpEmail)
  Future<HttpResponse<VerifyOtpResponse>> verifyOtpEmail(
      @Body() Map<String, dynamic> emailOtpMap);
}
