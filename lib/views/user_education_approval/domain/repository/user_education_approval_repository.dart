import 'package:job_portal/utils/resourses/data_state.dart';
import '../../data/models/user_education_approval_response_model.dart';
import '../../data/models/user_education_request_model.dart';

abstract class UserEducationApprovalRepository {
  Future<DataState<UserEducationResponse>> getMasterData();
  Future<DataState<dynamic>> updateUserEducation(int id, UserEducationRequest request);
}