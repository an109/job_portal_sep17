import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/Common_Screens/presentation/bloc/forgot_password_event.dart';
import 'package:job_portal/views/Common_Screens/presentation/bloc/forgot_password_state.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/usecase/forgot_password_usecases.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final SendOtpToEmailUsecase sendOtpToEmailUsecase;
  final VerifyOtpAndResetPasswordUsecase verifyOtpAndResetPasswordUsecase;

  ForgotPasswordBloc({
    required this.sendOtpToEmailUsecase,
    required this.verifyOtpAndResetPasswordUsecase,
  }) : super(ForgotPasswordInitial()) {
    on<SendForgotPasswordEmail>(_onSendOtp);
    on<ResetPasswordRequestEvent>(_onResetPassword);
  }

  Future<void> _onSendOtp(
      SendForgotPasswordEmail event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(ForgotPasswordLoading());
    final result = await sendOtpToEmailUsecase.call(event.email);

    if (result is DataSuccess<String>) {
      // ✅ Use ! because you know it's not null (ensured in repository)
      emit(ForgotPasswordOtpSent(result.data!));
    } else if (result is DataFailed) {
      emit(ForgotPasswordOtpFailed(result.error.toString()));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordRequestEvent event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(ResetPasswordLoading());
    final result = await verifyOtpAndResetPasswordUsecase.call(
      email: event.email,
      otp: event.otp,
      newPassword: event.newPassword,
    );

    if (result is DataSuccess<String>) {
      // ✅ Safe: Only emit if data is not null
      final message = result.data ?? 'Password changed successfully';
      developer.log('✅ Emitting ResetPasswordSuccess: $message');
      emit(ResetPasswordSuccess(result.data ?? 'Password changed'));
    } else if (result is DataFailed) {
      emit(ResetPasswordFailed(result.error.toString()));
    }
  }

  // Future<void> _onResetPassword(
  //     ResetPasswordRequestEvent event,
  //     Emitter<ForgotPasswordState> emit,
  //     ) async {
  //   emit(ResetPasswordLoading());
  //   final result = await verifyOtpAndResetPasswordUsecase.call(
  //     email: event.email,
  //     otp: event.otp,
  //     newPassword: event.newPassword,
  //   );
  //
  //   if (result is DataSuccess<String>) {
  //     emit(ResetPasswordSuccess(result.data!));
  //   } else if (result is DataFailed) {
  //     emit(ResetPasswordFailed(result.error.toString()));
  //   }
  // }
}