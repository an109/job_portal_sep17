import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:job_portal/utils/constants/urls.dart';
import '../models/user_auth_otp_response_model.dart';

part 'user_auth_otp_api_service.g.dart';

@RestApi()
abstract class UserAuthOtpApiService {
  factory UserAuthOtpApiService(Dio dio, {String baseUrl}) = _UserAuthOtpApiService;

  @POST(Urls.sendOtpMobile)
  Future<UserAuthOtpResponseModel> sendOtpToMobile(@Body() Map<String, dynamic> body);

  @POST(Urls.verifyOtpMobile)
  Future<UserAuthOtpResponseModel> verifyPhoneNumber(@Body() Map<String, dynamic> body);
}