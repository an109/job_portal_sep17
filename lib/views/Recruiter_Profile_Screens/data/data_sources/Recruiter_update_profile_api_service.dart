import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:job_portal/utils/constants/urls.dart';
import '../models/Recruiter_update_profile_response_model.dart';

part 'Recruiter_update_profile_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class RecruiterUpdateProfileApiService {
  factory RecruiterUpdateProfileApiService(Dio dio, {String? baseUrl}) = _RecruiterUpdateProfileApiService;

  @PUT(Urls.updateRecruiterProfile)
  Future<RecruiterUpdateProfileResponse> updateProfile(@Body() Map<String, dynamic> body);
}