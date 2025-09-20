import 'package:bloc/bloc.dart';
import 'package:job_portal/views/university_register/presentation/bloc/university_registration_event.dart';
import 'package:job_portal/views/university_register/presentation/bloc/university_registration_state.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/entities/university_registration_entity.dart';
import '../../domain/usecase/university_registration_usecase.dart';

class UniversityRegistrationBloc extends Bloc<UniversityRegistrationEvent, UniversityRegistrationState> {
  final RegisterUniversityUseCase _useCase;

  UniversityRegistrationBloc(this._useCase) : super(UniversityRegistrationInitial()) {
    on<RegisterUniversityEvent>((event, emit) async {
      emit(UniversityRegistrationLoading());

      final result = await _useCase.call(event.entity);

      if (result is DataSuccess<UniversityRegistrationEntity>) {
        emit(UniversityRegistrationSuccess(result.data!));
      } else if (result is DataFailed) {
        emit(UniversityRegistrationFailure(result.error?.message ?? 'Unknown error'));
      }
    });
  }
}