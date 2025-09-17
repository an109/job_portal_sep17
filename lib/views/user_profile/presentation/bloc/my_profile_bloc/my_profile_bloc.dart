import 'dart:developer' as developer;

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/domain/usecases/profile_usecases.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/my_profile_bloc/my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  Map<String, dynamic> skillCertificates = {};

  final UserDetailUsecase _userDetailUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;

  MyProfileBloc(this._userDetailUsecase, this._updateUserProfileUsecase)
      : super(const MyProfileInitial()) {
    on<LoadMyProfileDetails>(_onLoadProfileDetails);
    on<LoadUpdateProfile>(_onUpdateUserProfile);
  }

  Future<void> _onLoadProfileDetails(
      LoadMyProfileDetails event, Emitter<MyProfileState> emit) async {
    try {
      developer.log('🔍 [MyProfileBloc] _onLoadProfileDetails triggered');
      developer.log('📥 [MyProfileBloc] Loading profile for ID: ${event.id}');

      emit(const MyProfileDetailsLoading());
      final map = {'id': event.id};
      final response = await _userDetailUsecase(params: map);

      developer.log('✅ [MyProfileBloc] LoadProfile: API call succeeded');
      developer.log('📋 [MyProfileBloc] Raw userDetail response: ${response.data}');

      if (response.data == null) {
        developer.log('❌ [MyProfileBloc] LoadProfile: response.data is null');
        emit(const MyProfileDetailsError());
        return;
      }

      emit(MyProfileDetailsLoaded(response.data!));
      developer.log('🟢 [MyProfileBloc] MyProfileDetailsLoaded emitted');
    } catch (e, stackTrace) {
      developer.log('💥 [MyProfileBloc] Error in _onLoadProfileDetails: $e');
      developer.log('📊 [MyProfileBloc] Stack trace: $stackTrace');
      emit(const MyProfileDetailsError());
    }
  }

  Future<void> _onUpdateUserProfile(
      LoadUpdateProfile event, Emitter<MyProfileState> emit) async {
    try {
      developer.log('🔍 [MyProfileBloc] _onUpdateUserProfile triggered');
      developer.log('📥 [MyProfileBloc] Updating profile for ID: ${event.id}');
      developer.log('📝 [MyProfileBloc] Payload (params): ${event.params}');

      emit(const UpdateProfileLoading());
      final map = {'id': event.id, 'params': event.params};
      final response = await _updateUserProfileUsecase(params: map);

      developer.log('✅ [MyProfileBloc] UpdateProfile: API call succeeded');
      developer.log('📋 [MyProfileBloc] Raw update response: ${response.data}');

      if (response.data == null) {
        developer.log('❌ [MyProfileBloc] UpdateProfile: response.data is null');
        emit(const UpdateProfileError());
        return;
      }

      emit(UpdateProfileLoaded(response.data!));
      developer.log('🟢 [MyProfileBloc] UpdateProfileLoaded emitted');
    } catch (e, stackTrace) {
      developer.log('💥 [MyProfileBloc] Error in _onUpdateUserProfile: $e');
      developer.log('📊 [MyProfileBloc] Stack trace: $stackTrace');
      emit(const UpdateProfileError());
    }
  }
}