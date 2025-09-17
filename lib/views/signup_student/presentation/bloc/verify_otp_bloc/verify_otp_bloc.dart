import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/signup_student/domain/usecase/signup_usecase.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_event.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/verify_otp_bloc/verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpEmailUsecase _verifyOtpEmailUsecase;
  VerifyOtpBloc(this._verifyOtpEmailUsecase) : super(const VerifyOtpInitial()) {
    on<LoadVerifyOtp>(_onVerifyOtpEmail);
  }

  Future<void> _onVerifyOtpEmail(
      LoadVerifyOtp event, Emitter<VerifyOtpState> emit) async {
    try {
      emit(const VerifyOtpLoading());
      final response = await _verifyOtpEmailUsecase(params: event.emailOtpMap);
      emit(VerifyOtpLoaded(response.data!));
    } catch (e) {
      emit(const VerifyOtpError());
    }
  }
}
