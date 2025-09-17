import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_application/presentation/bloc/recruiter_application_event.dart';
import 'package:job_portal/views/recruiter_application/presentation/bloc/recruiter_application_state.dart';
import '../../../../utils/resourses/data_state.dart';
import '../../domain/usecases/recruiter_application_usecase.dart';

class RecruiterApplicationBloc
    extends Bloc<RecruiterApplicationEvent, RecruiterApplicationState> {
  final RecruiterApplicationUseCase useCase;

  RecruiterApplicationBloc({required this.useCase}) : super(RecruiterApplicationInitial()) {
    on<FetchRecruiterApplications>((event, emit) async {
      emit(RecruiterApplicationLoading());
      final result = await useCase(event.jobPostId);

      if (result is DataSuccess) {
        final applications = result.data ?? [];
        emit(RecruiterApplicationLoaded(applications));
      } else if (result is DataFailed) {
        final message = result.error?.message ?? 'Failed to load applicants';
        emit(RecruiterApplicationError(message));
      }
    });
  }
}