import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/domain/usecases/user_auth_otp_usecase.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/presentation/bloc/user_auth_event.dart';
import 'package:job_portal/views/user_authentication_and_approval_screens/presentation/bloc/user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final SendOtpToMobileUseCase sendOtpToMobileUseCase;
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;

  UserAuthBloc({
    required this.sendOtpToMobileUseCase,
    required this.verifyPhoneNumberUseCase,
  }) : super(UserAuthInitial()) {
    on<SendOtpToMobileEvent>(_onSendOtp);
    on<VerifyPhoneNumberEvent>(_onVerifyPhoneNumber);
  }

  Future<void> _onSendOtp(SendOtpToMobileEvent event, Emitter<UserAuthState> emit) async {
    emit(UserAuthLoading());
    try {
      final result = await sendOtpToMobileUseCase(phoneNumber: event.phoneNumber);
      if (result.success) {
        emit(UserAuthSuccess(result.message));
      } else {
        emit(UserAuthFailure(result.message));
      }
    } catch (e) {
      emit(UserAuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyPhoneNumber(VerifyPhoneNumberEvent event, Emitter<UserAuthState> emit) async {
    emit(UserAuthLoading());
    try {
      final result = await verifyPhoneNumberUseCase(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      );
      if (result.success) {
        emit(UserAuthSuccess(result.message));
      } else {
        emit(UserAuthFailure(result.message));
      }
    } catch (e) {
      emit(UserAuthFailure(e.toString()));
    }
  }
}