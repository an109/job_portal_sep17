import 'package:job_portal/views/user_authentication_and_approval_screens/domain/repository/user_auth_otp_repository.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/domain/entities/user_auth_otp_entity.dart';

class SendOtpToMobileUseCase {
  final UserAuthOtpRepository repository;

  SendOtpToMobileUseCase(this.repository);

  Future<UserAuthOtpEntity> call({required String phoneNumber}) {
    return repository.sendOtpToMobile(phoneNumber: phoneNumber);
  }
}

class VerifyPhoneNumberUseCase {
  final UserAuthOtpRepository repository;

  VerifyPhoneNumberUseCase(this.repository);

  Future<UserAuthOtpEntity> call({required String phoneNumber, required String otp}) {
    return repository.verifyPhoneNumber(phoneNumber: phoneNumber, otp: otp);
  }
}