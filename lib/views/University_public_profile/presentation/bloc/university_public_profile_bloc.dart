// lib/University_public_profile/presentation/bloc/university_public_profile_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/university_public_profile_usecase.dart';
import 'university_public_profile_event.dart';
import 'university_public_profile_state.dart';

class UniversityPublicProfileBloc extends Bloc<UniversityPublicProfileEvent, UniversityPublicProfileState> {
  final UniversityPublicProfileUseCase _useCase;

  UniversityPublicProfileBloc(this._useCase) : super( UniversityPublicProfileInitial()) {
    on<FetchUniversityPublicProfile>(_onFetchUniversityPublicProfile);
  }

  Future<void> _onFetchUniversityPublicProfile(
      FetchUniversityPublicProfile event,
      Emitter<UniversityPublicProfileState> emit,
      ) async {
    emit( UniversityPublicProfileLoading());

    try {
      final profile = await _useCase(event.userId);
      emit(UniversityPublicProfileLoaded(profile));
    } catch (e) {
      emit(UniversityPublicProfileError(e.toString()));
    }
  }
}