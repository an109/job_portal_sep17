import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/domain/usecases/profile_usecases.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/manage_account_bloc/manage_account_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/manage_account_bloc/manage_account_state.dart';

import '../../../../../utils/resourses/data_state.dart';
import '../../../domain/usecases/change_password_usecase.dart';

class ManageAccountBloc extends Bloc<ManageAccountEvent, ManageAccountState> {
  final UpdateUserEmailUsecase _updateUserEmailUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;

  ManageAccountBloc(this._updateUserEmailUsecase, this._changePasswordUsecase)
      : super(const ManageAccountInitial()) {
    on<LoadChangeEmail>(_onChangeEmail);
    on<LoadChangePassword>(_onChangePassword);
  }

  Future<void> _onChangeEmail(
      LoadChangeEmail event, Emitter<ManageAccountState> emit) async {
    try {
      emit(const ChangeEmailLoading());
      final response = await _updateUserEmailUsecase(params: event.params);
      emit(ChangeEmailLoaded(response.data!));
    } catch (e) {

      emit(ChangeEmailError('$e'));
    }
  }
  Future<void> _onChangePassword(
      LoadChangePassword event, Emitter<ManageAccountState> emit) async {
    try {
      emit( ChangePasswordLoading());
      final result = await _changePasswordUsecase(params: event.params);
      if (result is DataSuccess && result.data != null) {
        emit(ChangePasswordLoaded(result.data!));
      } else if (result is DataFailed) {
        emit(ChangePasswordError(result.error.toString()));
      } else {
        emit(ChangePasswordError('Unknown error'));
      }
    } catch (e) {
      emit(ChangePasswordError('Network error: $e'));
    }
  }
}
