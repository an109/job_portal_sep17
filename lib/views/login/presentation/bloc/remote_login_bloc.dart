import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/login/domain/usecases/login_usecase.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_event.dart';
import 'package:job_portal/views/login/presentation/bloc/remote_login_state.dart';

class RemoteLoginBloc extends Bloc<RemoteLoginEvent, RemoteLoginState> {
  final LoginUsecase _loginUsecase;
  final LoginSendOtpEmailUsecase _loginSendOtpEmailUsecase;
  final LoginVerifyOtpEmailUsecase _verifyOtpEmailUsecase;

  RemoteLoginBloc(this._loginUsecase, this._loginSendOtpEmailUsecase,
      this._verifyOtpEmailUsecase)
      : super(const RemoteLoginInitialize()) {
    on<RemoteLoginData>(_onLogin);
    on<RemoteLoginSentOtpData>(_onSendOtpEmail);
    on<RemoteLoginVerifyOtpData>(_onVerifyOtpEmail);
  }

  Future<void> _onLogin(
      RemoteLoginData event, Emitter<RemoteLoginState> emit) async {
    try {
      emit(const RemoteLoginLoading());
      final response = await _loginUsecase.userLogin(event.loginMap);
      developer.log('Ending up in bloc succes : ${response.data!}');

      emit(RemoteLoginLoaded(response.data!));
    } catch (e) {
      developer.log('Ending up in bloc error : ${e.toString()}');
      emit(const RemoteLoginError());
    }
  }

  Future<void> _onSendOtpEmail(
      RemoteLoginSentOtpData event, Emitter<RemoteLoginState> emit) async {
    try {
      emit(const RemoteLoginSendOtpLoading());
      final response = await _loginSendOtpEmailUsecase(params: event.emailMap);
      emit(RemoteLoginSendOtpLoaded(response.data!));
    } catch (e) {
      emit(const RemoteLoginSendOtpError());
    }
  }

  Future<void> _onVerifyOtpEmail(
      RemoteLoginVerifyOtpData event, Emitter<RemoteLoginState> emit) async {
    try {
      emit(const RemoteLoginVerifyOtpLoading());
      final response = await _verifyOtpEmailUsecase(params: event.emailOtpMap);
      emit(RemoteLoginVerifyOtpLoaded(response.data!));
    } catch (e) {
      emit(const RemoteLoginVerifyOtpError());
    }
  }
}
