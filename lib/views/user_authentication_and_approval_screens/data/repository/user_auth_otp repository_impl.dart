import 'package:job_portal/views/user_authentication_and_approval_screens/data/data_source/user_auth_otp_api_service.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/domain/entities/user_auth_otp_entity.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/domain/repository/user_auth_otp_repository.dart';

class UserAuthOtpRepositoryImpl implements UserAuthOtpRepository {
  final UserAuthOtpApiService apiService;

  UserAuthOtpRepositoryImpl({required this.apiService});

  @override
  Future<UserAuthOtpEntity> sendOtpToMobile({required String phoneNumber}) async {
    final response = await apiService.sendOtpToMobile({'phoneNumber': phoneNumber});
    return UserAuthOtpEntity(success: response.success, message: response.message);
  }

  @override
  Future<UserAuthOtpEntity> verifyPhoneNumber({required String phoneNumber, required String otp}) async {
    final response = await apiService.verifyPhoneNumber({
      'phoneNumber': phoneNumber,
      'otp': otp,
    });
    return UserAuthOtpEntity(success: response.success, message: response.message);
  }
}