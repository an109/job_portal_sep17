import 'package:bloc/bloc.dart';
import 'package:job_portal/views/University_profile_screen/presentation/bloc/university_profile_event.dart';
import 'package:job_portal/views/University_profile_screen/presentation/bloc/university_profile_state.dart';

import '../../domain/usecases/university_profile_usecase.dart';


class UniversityProfileBloc extends Bloc<UniversityProfileEvent, UniversityProfileState> {
  final UpdateUniversityProfileUseCase _useCase;

  UniversityProfileBloc(this._useCase) : super( UniversityProfileInitial()) {
    on<LoadUniversityProfile>((event, emit) async {
      emit( UniversityProfileLoading());

    });

    on<SaveUniversityProfile>((event, emit) async {
      emit( UniversityProfileLoading());
      try {
        await _useCase.call(event.entity);
        emit(UniversityProfileSuccess(event.entity));
      } catch (e) {
        emit(UniversityProfileFailure(e.toString()));
      }
    });
  }
}