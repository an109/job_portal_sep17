// lib/presentation/bloc/university_followers_following_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:job_portal/views/university_followers_following/presentation/bloc/university_followers_following_event.dart';
import 'package:job_portal/views/university_followers_following/presentation/bloc/university_followers_following_state.dart';


import '../../domain/usecases/university_followers_following_usecase.dart';

class UniversityFollowersFollowingBloc extends Bloc<UniversityFollowersFollowingEvent, UniversityFollowersFollowingState> {
  final GetFollowersUseCase _getFollowersUseCase;
  final GetFollowingUseCase _getFollowingUseCase;

  UniversityFollowersFollowingBloc(
      this._getFollowersUseCase,
      this._getFollowingUseCase,
      ) : super(InitialUniversityFollowersFollowingState()) {
    on<LoadFollowers>(_onLoadFollowers);
    on<LoadFollowing>(_onLoadFollowing);

    on<LoadFollowersCount>(_onLoadFollowersCount);
    on<LoadFollowingCount>(_onLoadFollowingCount);
  }

  void _onLoadFollowers(LoadFollowers event, Emitter<UniversityFollowersFollowingState> emit) async {
    emit(FollowersLoading());
    try {
      final followers = await _getFollowersUseCase.call(event.userId);
      emit(FollowersLoaded(followers));
    } catch (e) {
      emit(FollowersError(e.toString()));
    }
  }

  void _onLoadFollowing(LoadFollowing event, Emitter<UniversityFollowersFollowingState> emit) async {
    emit(FollowingLoading());
    try {
      final following = await _getFollowingUseCase.call(event.userId);
      emit(FollowingLoaded(following));
    } catch (e) {
      emit(FollowingError(e.toString()));
    }
  }

  void _onLoadFollowersCount(LoadFollowersCount event, Emitter<UniversityFollowersFollowingState> emit) async {
    emit(FollowersCountLoading());
    try {
      final followers = await _getFollowersUseCase.call(event.userId);
      final count = followers is List ? followers.length : 0;
      emit(FollowersCountLoaded(count));
    } catch (e) {
      emit(FollowersCountError(e.toString()));
    }
  }

  void _onLoadFollowingCount(LoadFollowingCount event, Emitter<UniversityFollowersFollowingState> emit) async {
    emit(FollowingCountLoading());
    try {
      final following = await _getFollowingUseCase.call(event.userId);
      final count = following is List ? following.length : 0;
      emit(FollowingCountLoaded(count));
    } catch (e) {
      emit(FollowingCountError(e.toString()));
    }
  }
}