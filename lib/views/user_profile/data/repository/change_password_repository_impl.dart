import 'package:dio/dio.dart';
import 'package:job_portal/utils/resourses/data_state.dart';
import '../../../Common_Screens/data/data_source/forgot_password_api_service.dart';
import '../../domain/repository/change_password_repository.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ForgotPasswordApiService _apiService;

  ChangePasswordRepositoryImpl(this._apiService);

  @override
  Future<DataState<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.changePassword({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      if (response.response.statusCode == 200) {
        final data = response.response.data as Map<String, dynamic>?; // Safe cast
        final message = data?['message'] as String? ?? 'Password updated successfully';
        return DataSuccess(message);
      } else {
        final error = response.response.statusMessage ?? 'Failed to update password';
        return DataFailed(
          DioException(
            error: error,
            requestOptions: response.response.requestOptions,
            response: response.response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}