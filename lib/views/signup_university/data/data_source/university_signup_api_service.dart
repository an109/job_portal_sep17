import 'package:dio/dio.dart';
import 'package:job_portal/utils/constants/urls.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/courses_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../../signup_student/data/models/send_otp_email_response.dart';
import '../../../signup_student/data/models/signup_user_response.dart';
import '../../../signup_student/data/models/verify_otp_response.dart';

part 'university_signup_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UniversitySignupApiService {
  factory UniversitySignupApiService(Dio dio, {String? baseUrl}) =
      _UniversitySignupApiService;

  @GET(Urls.getCourses)
  Future<HttpResponse<CourseListModel>> getCourses();
  //
  // @POST(Urls.userRegisteration)
  // Future<HttpResponse<SignUpUserResponse>> registerUser(
  //     @Body() Map<String, dynamic> registerationMap);
  //
  // @POST(Urls.sendOtpEmail)
  // Future<HttpResponse<SendOtpEmailResponse>> sendOtpEmail(
  //     @Body() Map<String, dynamic> emailMap);
  //
  // @POST(Urls.verifyOtpEmail)
  // Future<HttpResponse<VerifyOtpResponse>> verifyOtpEmail(
  //     @Body() Map<String, dynamic> emailOtpMap);


}

// List<dynamic>
