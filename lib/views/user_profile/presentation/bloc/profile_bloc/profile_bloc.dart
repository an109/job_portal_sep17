import 'dart:developer' as developer show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/user_profile/domain/usecases/profile_usecases.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:job_portal/views/user_profile/presentation/bloc/profile_bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUsecase _profileUsecase;
  final GetFollowersUsecase _getFollowersUsecase;
  final GetFollowingUsecase _getFollowingUsecase;
  ProfileBloc(this._profileUsecase, this._getFollowersUsecase,
      this._getFollowingUsecase)
      : super(const ProfileInitial()) {
    on<LoadPublicProfile>(_onLoadPublicProfile);
    on<LoadPublicProfileWithFollowersAndFollowing>(
        _onLoadPublicProfileWithFollowersAndFollowing);
  }

  Future<void> _onLoadPublicProfile(
      LoadPublicProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(const PublicProfileLoading());
      final map = {'id': event.id};
      final respones = await _profileUsecase(params: map);
      // developer.log('checking in bloc : ${respones.data!.first_name}');
      emit(PublicProfileLoaded(respones.data!));
    } catch (e) {
      developer.log('checking error in bloc : ${e}');

      emit(const PublicProfileError());
    }
  }

  Future<void> _onLoadPublicProfileWithFollowersAndFollowing(
      LoadPublicProfileWithFollowersAndFollowing event,
      Emitter<ProfileState> emit) async {
    try {
      emit(const PublicProfileWithFollowersAndFollowingLoading());
      final map = {'id': event.id};
      final profile = await _profileUsecase(params: map);
      final followers = await _getFollowersUsecase(params: map);
      final followings = await _getFollowingUsecase(params: map);
      // developer.log('checking in bloc : ${respones.data!.first_name}');
      emit(PublicProfileWithFollowersAndFollowingLoaded(
          profile.data!, followers.data!, followings.data!));
    } catch (e) {
      developer.log('checking error in bloc : ${e}');

      emit(const PublicProfileWithFollowersAndFollowingError());
    }
  }
}
