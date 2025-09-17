import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/Recruiter_update_profile_entity.dart';
import '../../domain/usecases/Recruiter_update_profile_usecase.dart';
import 'Recruiter_update_profile_event.dart';
import 'Recruiter_update_profile_state.dart';

class RecruiterUpdateProfileBloc
    extends Bloc<RecruiterUpdateProfileEvent, RecruiterUpdateProfileState> {
  final RecruiterUpdateProfileUseCase _useCase;

  RecruiterUpdateProfileBloc(this._useCase) : super(InitialState()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<InitialEvent>((event, emit) => emit(InitialState()));
  }

  void _onUpdateProfile(
      UpdateProfileEvent event,
      Emitter<RecruiterUpdateProfileState> emit,
      ) async {
    emit(LoadingState());

    try {
      final entity = RecruiterUpdateProfileEntity(
          about: event.about.isEmpty ? null : event.about,
          hiringPreferences: event.hiringPreferences.isEmpty ? null : event.hiringPreferences,
          languageIds: event.languageIds.isEmpty ? null : event.languageIds,
          profilePic: event.profilePic,
      );

      final result = await _useCase.call(entity);
      emit(SuccessState(result.message));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

// Optional helper (uncomment if you need language mapping)
// List<int> _parseLanguages(String languages) {
//   final langMap = {'Hindi': 1, 'English': 2, 'Spanish': 3, 'French': 4};
//   return languages
//       .split(',')
//       .map((lang) => lang.trim())
//       .where((lang) => langMap.containsKey(lang))
//       .map((lang) => langMap[lang]!)
//       .toList();
// }
}