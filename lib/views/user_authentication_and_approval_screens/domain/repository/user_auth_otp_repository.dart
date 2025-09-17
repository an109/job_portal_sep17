import 'package:job_portal/views/user_authentication_and_approval_screens/domain/entities/user_auth_otp_entity.dart';

abstract class UserAuthOtpRepository {
  Future<UserAuthOtpEntity> sendOtpToMobile({required String phoneNumber});
  Future<UserAuthOtpEntity> verifyPhoneNumber({required String phoneNumber, required String otp});
}