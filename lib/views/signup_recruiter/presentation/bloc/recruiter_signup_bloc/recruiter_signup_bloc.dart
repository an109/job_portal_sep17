import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/signup_recruiter/domain/usecases/recruiter_signup_usecase.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/recruiter_signup_bloc/recruiter_signup_state.dart';
import 'package:job_portal/views/signup_recruiter/presentation/bloc/recruiter_signup_bloc/recruiter_singup_event.dart';

class RecruiterSignupBloc
    extends Bloc<RecruiterSignupEvent, RecruiterSignupState> {
  final RecruiterSignupUsecase _recruiterSignupUsecase;
  final SendOtpEmailRecruiterUsecase _sendOtpEmailRecruiterUsecase;
  RecruiterSignupBloc(
      this._recruiterSignupUsecase, this._sendOtpEmailRecruiterUsecase)
      : super(const RecruiterSignupInitialize()) {
    on<RecruiterSignupData>(_onRecruiterSignup);
    on<RecruiterSignupSendOtpEmail>(_onSendOtp);
  }

  Future<void> _onRecruiterSignup(
      RecruiterSignupData event, Emitter<RecruiterSignupState> emit) async {
    try {
      emit(const RecruiterSignupLoading());
      final response =
          await _recruiterSignupUsecase(params: event.registerationMap);
      developer.log(
          'Check recruiter signup in bloc before emiting : ${response.data?.message}');
      emit(RecruiterSignupLoaded(response.data!));
    } catch (e) {
      developer.log('Error encounter on email already exist in rec bloc : $e');
      emit(const RecruiterSignupError());
    }
  }

  Future<void> _onSendOtp(RecruiterSignupSendOtpEmail event,
      Emitter<RecruiterSignupState> emit) async {
    try {
      emit(const RecruiterSignupSendOtpLoading());
      final response =
          await _sendOtpEmailRecruiterUsecase(params: event.emailMap);
      developer.log(
          'Check recruiter signup in bloc before emiting : ${response.data?.message}');
      emit(RecruiterSignupSendOtpLoaded(response.data!));
    } catch (e) {
      developer.log('Error encounter on email already exist in rec bloc : $e');
      emit(const RecruiterSignupSendOtpError());
    }
  }
}
