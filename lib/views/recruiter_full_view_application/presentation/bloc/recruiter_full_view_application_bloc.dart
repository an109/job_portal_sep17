import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_full_view_application/presentation/bloc/recruiter_full_view_application_event.dart';
import 'package:job_portal/views/recruiter_full_view_application/presentation/bloc/recruiter_full_view_application_state.dart';

import '../../../../utils/resourses/data_state.dart';
import '../../domain/usecases/recruiter_full_view_application_usecase.dart';


class RecruiterFullViewApplicationBloc extends Bloc<RecruiterFullViewApplicationEvent, RecruiterFullViewApplicationState> {
  final GetApplicantDetailsUseCase useCase;

  RecruiterFullViewApplicationBloc({required this.useCase}) : super(RecruiterFullViewApplicationInitial()) {
    on<FetchRecruiterFullViewApplications>((event, emit) async {
      emit(RecruiterFullViewApplicationLoading());
      final result = await useCase.call(event.jobId, event.applicantId);

      if (result is DataSuccess) {
        final applicant = result.data;
        if (applicant != null) {
          emit(RecruiterFullViewApplicationSuccess(applicant));
        } else {
          emit(RecruiterFullViewApplicationFailed('Applicant data is null'));
        }
      } else if (result is DataFailed) {
        final message = result.error?.toString() ?? 'Failed to load applicant details';
        emit(RecruiterFullViewApplicationFailed(message));
      }
    });
  }
}