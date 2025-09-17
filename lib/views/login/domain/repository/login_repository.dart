import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/views/login/data/models/login_user_response.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

abstract class LoginRepository {
  Future<DataState<LoginUserResponse>> userLogin(Map<String, dynamic> loginMap);

  Future<DataState<SendOtpEmailEntity>> sendOtpEmail(
      Map<String, dynamic> emailMap);

  Future<DataState<VerifyOtpEntity>> verifyOtpResponse(
      Map<String, dynamic> emailOtpMap);
}
