import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/signup_student/data/models/signup_user_response.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

abstract class SignupRepository {
  Future<DataState<SignUpUserResponse>> registerUser(
      Map<String, dynamic> registerationMap);

  Future<DataState<SendOtpEmailEntity>> sendOtpEmail(
      Map<String, dynamic> emailMap);

  Future<DataState<VerifyOtpEntity>> verifyOtpResponse(
      Map<String, dynamic> emailOtpMap);
}
