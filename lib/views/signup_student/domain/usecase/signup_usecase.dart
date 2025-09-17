import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/usecase/usecases.dart';
import 'package:job_portal/views/signup_student/data/models/signup_user_response.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';
import 'package:job_portal/views/signup_student/domain/repository/signup_repository.dart';

class SignupUsecase {
  final SignupRepository _signupRepository;

  SignupUsecase(this._signupRepository);

  Future<DataState<SignUpUserResponse>> registerUser(
      Map<String, dynamic> registerationMap) async {
    final response = await _signupRepository.registerUser(registerationMap);
    return response;
  }
}

class SendOtpEmailUsecase
    implements UseCase<DataState<SendOtpEmailEntity>, Map<String, dynamic>> {
  final SignupRepository _repository;
  SendOtpEmailUsecase(this._repository);

  @override
  Future<DataState<SendOtpEmailEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.sendOtpEmail(params!);
  }
}

class VerifyOtpEmailUsecase
    implements UseCase<DataState<VerifyOtpEntity>, Map<String, dynamic>> {
  final SignupRepository _repository;
  VerifyOtpEmailUsecase(this._repository);

  @override
  Future<DataState<VerifyOtpEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.verifyOtpResponse(params!);
  }
}
