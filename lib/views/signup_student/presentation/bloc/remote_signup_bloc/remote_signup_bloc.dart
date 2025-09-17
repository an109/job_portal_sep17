import 'dart:developer' as developer show log;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/signup_student/domain/usecase/signup_usecase.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_event.dart';
import 'package:job_portal/views/signup_student/presentation/bloc/remote_signup_bloc/remote_signup_state.dart';

class RemoteSignupBloc extends Bloc<RemoteSignupEvent, RemoteSignupState> {
  final SignupUsecase _signupUsecase;
  final SendOtpEmailUsecase _sendOtpEmailUsecase;

  RemoteSignupBloc(this._signupUsecase, this._sendOtpEmailUsecase)
      : super(const RemoteSignupInitial()) {
    on<RemoteSignupData>(_onSignUpData);
    on<RemoteSingupSendOtpEmail>(_onSendOtpEmail);
    // on<RemoteSignupGetBasicUserInfo>(_onGetBasicUserInfo);
  }

  Future<void> _onSignUpData(
      RemoteSignupData event, Emitter<RemoteSignupState> emit) async {
    try {
      emit(const RemoteSignupLoading());
      final response =
          await _signupUsecase.registerUser(event.registerationMap);
      developer.log('Response of register user : ${response.data!.message}');
      emit(RemoteSignupDone(response.data!));
    } catch (e) {
      developer.log('Ending up in error : $e');
      emit(const RemoteSignupError());
    }
  }

  Future<void> _onSendOtpEmail(
      RemoteSingupSendOtpEmail event, Emitter<RemoteSignupState> emit) async {
    try {
      emit(const RemoteSignupSendOtpEmailLoading());
      final response = await _sendOtpEmailUsecase(params: event.emailMap);
      emit(RemoteSignupSendOtpEmailDone(response.data!));
    } catch (e) {
      emit(const RemoteSignupSendOtpEmailError());
    }
  }
}
