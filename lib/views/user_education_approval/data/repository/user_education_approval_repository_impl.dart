import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import '../../domain/repository/user_education_approval_repository.dart';
import '../data_sources/user_education_approval_api_service.dart';
import '../models/user_education_approval_response_model.dart';
import '../models/user_education_request_model.dart';

class UserEducationApprovalRepositoryImpl implements UserEducationApprovalRepository {
  final UserEducationApprovalApiService apiService;

  UserEducationApprovalRepositoryImpl(this.apiService);

  @override
  Future<DataState<UserEducationResponse>> getMasterData() async {
    try {
      final response = await apiService.getMasterAllData();
      return DataSuccess(response);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<dynamic>> updateUserEducation(int id, UserEducationRequest request) async {
    try {
      final response = await apiService.updateUserEducation(id, request);


      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DataSuccess(response.data);
      } else {

        return DataFailed(DioException(
          error: response.statusMessage,
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}