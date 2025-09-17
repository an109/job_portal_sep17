import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/urls.dart';
import '../models/user_skill_approval_response_model.dart';

part 'user_skill_approval_api_service.g.dart';

@RestApi(baseUrl: Urls.baseUrl)
abstract class UserSkillApprovalApiService {
  factory UserSkillApprovalApiService(Dio dio, {String? baseUrl}) = _UserSkillApprovalApiService;

  @GET("${Urls.getUserDetails}{userId}")
  Future<UserSkillApprovalResponseModel> getUserSkills(
      @Path("userId") int userId,
      );

  @PUT("${Urls.updateUserDetailsById}{userId}")
  Future<void> updateUserSkills(
      @Path("userId") int userId,
      @Body() Map<String, dynamic> body,
      );
}