import 'package:job_portal/utils/resourses/data_state.dart';
import 'package:job_portal/utils/usecase/usecases.dart';
import 'package:job_portal/views/signup_recruiter/domain/entities/sigup_user_entity.dart';
import 'package:job_portal/views/signup_recruiter/domain/repository/recruiter_signup_repository.dart';
import 'package:job_portal/views/signup_student/data/models/signup_user_response.dart';
import 'package:job_portal/views/signup_student/domain/entities/send_otp_email_entity.dart';
import 'package:job_portal/views/signup_student/domain/entities/verify_otp_entity.dart';

class RecruiterSignupUsecase
    implements UseCase<DataState<SignUpUserEntity>, Map<String, dynamic>> {
  final RecruiterSignupRepository _repository;
  RecruiterSignupUsecase(this._repository);

  @override
  Future<DataState<SignUpUserEntity>> call({Map<String, dynamic>? params}) {
    return _repository.registerUser(params ?? {});
  }
}

class SendOtpEmailRecruiterUsecase
    implements UseCase<DataState<SendOtpEmailEntity>, Map<String, dynamic>> {
  final RecruiterSignupRepository _repository;
  SendOtpEmailRecruiterUsecase(this._repository);

  @override
  Future<DataState<SendOtpEmailEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.sendOtpEmail(params!);
  }
}

class VerifyOtpEmailRecruiterUsecase
    implements UseCase<DataState<VerifyOtpEntity>, Map<String, dynamic>> {
  final RecruiterSignupRepository _repository;
  VerifyOtpEmailRecruiterUsecase(this._repository);

  @override
  Future<DataState<VerifyOtpEntity>> call(
      {Map<String, dynamic>? params}) async {
    return _repository.verifyOtpResponse(params!);
  }
}
