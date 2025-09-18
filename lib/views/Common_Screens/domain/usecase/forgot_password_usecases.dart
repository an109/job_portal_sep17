import 'package:job_portal/utils/resourses/data_state.dart';
import '../repository/forgot_password_repository.dart';

class SendOtpToEmailUsecase {
  final ForgotPasswordRepository repository;

  SendOtpToEmailUsecase(this.repository);

  Future<DataState<String>> call(String email) async {
    return await repository.sendOtpToEmail(email);
  }
}

class VerifyOtpAndResetPasswordUsecase {
  final ForgotPasswordRepository repository;

  VerifyOtpAndResetPasswordUsecase(this.repository);

  Future<DataState<String>> call({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await repository.verifyOtpAndResetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}

class ResetPasswordWithOtpUseCase {
  final ForgotPasswordRepository repository;

  ResetPasswordWithOtpUseCase(this.repository);

  Future<DataState<String>> call({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await repository.resetPasswordWithOTP(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}