import 'package:job_portal/utils/resourses/data_state.dart';

abstract class ForgotPasswordRepository {
  Future<DataState<String>> sendOtpToEmail(String email);
  Future<DataState<String>> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<DataState<String>> resetPasswordWithOTP({
    required String email,
    required String otp,
    required String newPassword,
  });

}