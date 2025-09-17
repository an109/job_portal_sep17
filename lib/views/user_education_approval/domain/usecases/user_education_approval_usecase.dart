import 'package:job_portal/utils/resourses/data_state.dart';
import '../../data/models/user_education_approval_response_model.dart';
import '../../data/models/user_education_request_model.dart';
import '../repository/user_education_approval_repository.dart';

class UserEducationApprovalUsecase {
  final UserEducationApprovalRepository repository;

  UserEducationApprovalUsecase(this.repository);

  Future<DataState<UserEducationResponse>> getMasterData() async {
    return await repository.getMasterData();
  }

  Future<DataState<dynamic>> updateUserEducation(int id, UserEducationRequest request) async {
    return await repository.updateUserEducation(id, request);
  }
}