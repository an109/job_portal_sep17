// university_profile_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/usecases/university_profile_usecase.dart';
import 'university_profile_event.dart';
import 'university_profile_state.dart';

class UniversityProfileBloc
    extends Bloc<UniversityProfileEvent, UniversityProfileState> {
  final UpdateUniversityProfileUseCase _updateUseCase;
  final GetUniversityProfileUseCase _getUseCase;

  UniversityProfileBloc({
    required UpdateUniversityProfileUseCase updateUseCase,
    required GetUniversityProfileUseCase getUseCase,
  })  : _updateUseCase = updateUseCase,
        _getUseCase = getUseCase,
        super(UniversityProfileInitial()) {
    on<LoadUniversityProfile>(_onLoadUniversityProfile);
    on<SaveUniversityProfile>(_onSaveUniversityProfile);
  }

  Future<void> _onLoadUniversityProfile(
      LoadUniversityProfile event,
      Emitter<UniversityProfileState> emit,
      ) async {
    emit(UniversityProfileLoading());
    final result = await _getUseCase.call();
    if (result is DataSuccess) {
      emit(UniversityProfileLoaded(result.data!));
    } else if (result is DataFailed) {
      emit(UniversityProfileFailure(result.error?.message ?? 'Failed to load profile'));
    }
  }

  Future<void> _onSaveUniversityProfile(
      SaveUniversityProfile event,
      Emitter<UniversityProfileState> emit,
      ) async {
    // Optional: Validate that at least one field is provided
    if (event.entity.props.every((prop) => prop == null)) {
      emit(const UniversityProfileFailure('No changes to save'));
      return;
    }

    emit(UniversityProfileLoading());
    final result = await _updateUseCase.call(event.entity);
    if (result is DataSuccess) {
      emit(UniversityProfileSuccess(event.entity));
    } else if (result is DataFailed) {
      emit(UniversityProfileFailure(result.error?.message ?? 'Update failed'));
    }
  }
}