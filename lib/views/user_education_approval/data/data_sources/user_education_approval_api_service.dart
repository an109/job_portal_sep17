import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:job_portal/utils/constants/urls.dart';
import '../models/user_education_approval_response_model.dart';
import '../models/user_education_request_model.dart';
part 'user_education_approval_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UserEducationApprovalApiService {
  factory UserEducationApprovalApiService(Dio dio, {String? baseUrl}) = _UserEducationApprovalApiService;

  @GET(Urls.getMasterAllData)
  Future<UserEducationResponse> getMasterAllData();

  @PUT('${Urls.updateUserDetailsById}{id}')
  Future<dynamic> updateUserEducation(
      @Path('id') int id,
      @Body() UserEducationRequest request,
      );
}