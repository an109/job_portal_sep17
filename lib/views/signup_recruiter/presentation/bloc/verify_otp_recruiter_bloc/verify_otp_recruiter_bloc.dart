import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/signup_recruiter/domain/usecases/recruiter_signup_usecase.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/verify_otp_recruiter_bloc/verify_otp_recruiter_event.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/verify_otp_recruiter_bloc/verify_otp_recruiter_state.dart';

class VerifyOtpRecruiterBloc
    extends Bloc<VerifyOtpRecruiterEvent, VerifyOtpRecruiterState> {
  final VerifyOtpEmailRecruiterUsecase _verifyOtpEmailRecruiterUsecase;
  VerifyOtpRecruiterBloc(this._verifyOtpEmailRecruiterUsecase)
      : super(const VerifyOtpRecruiterInitial()) {
    on<LoadVerifyRecruiterOtp>(_onVerifyOtpEmail);
  }

  Future<void> _onVerifyOtpEmail(LoadVerifyRecruiterOtp event,
      Emitter<VerifyOtpRecruiterState> emit) async {
    try {
      emit(const VerifyOtpRecruiterLoading());
      final response =
          await _verifyOtpEmailRecruiterUsecase(params: event.emailOtpMap);
      emit(VerifyOtpRecruiterLoaded(response.data!));
    } catch (e) {
      emit(const VerifyOtpRecruiterError());
    }
  }
}
