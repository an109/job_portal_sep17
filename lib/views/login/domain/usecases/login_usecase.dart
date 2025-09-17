import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/usecase/usecases.dart';
import 'package:job_portal/views/login/data/models/login_user_response.dart';
import 'package:job_portal/views/login/domain/repository/login_repository.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

class LoginUsecase {
  final LoginRepository _repository;

  LoginUsecase(this._repository);

  Future<DataState<LoginUserResponse>> userLogin(
      Map<String, dynamic> loginMap) async {
    final response = await _repository.userLogin(loginMap);
    return response;
  }
}

class LoginSendOtpEmailUsecase
    implements UseCase<DataState<SendOtpEmailEntity>, Map<String, dynamic>> {
  final LoginRepository _repository;
  LoginSendOtpEmailUsecase(this._repository);

  @override
  Future<DataState<SendOtpEmailEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.sendOtpEmail(params!);
  }
}

class LoginVerifyOtpEmailUsecase
    implements UseCase<DataState<VerifyOtpEntity>, Map<String, dynamic>> {
  final LoginRepository _repository;
  LoginVerifyOtpEmailUsecase(this._repository);

  @override
  Future<DataState<VerifyOtpEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.verifyOtpResponse(params!);
  }
}
