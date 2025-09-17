import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_schedule_interview/presentaion/bloc/recruiter_schedule_interview_event.dart';
import 'package:job_portal/views/recruiter_schedule_interview/presentaion/bloc/recruiter_schedule_interview_state.dart';

import '../../domain/usecases/recruiter_schedule_interview_usecase.dart';

class RecruiterScheduleInterviewBloc extends Bloc<RecruiterScheduleInterviewEvent, RecruiterScheduleInterviewState> {
  final RecruiterScheduleInterviewUseCase _useCase;

  RecruiterScheduleInterviewBloc(this._useCase) : super(RecruiterScheduleInterviewInitial()) {
    on<ScheduleInterviewRequested>(_onScheduleInterview);
  }

  void _onScheduleInterview(
      ScheduleInterviewRequested event,
      Emitter<RecruiterScheduleInterviewState> emit,
      ) async {
    emit(RecruiterScheduleInterviewLoading());

    try {
      final response = await _useCase(
        applicantId: event.applicantId,
        entity: event.entity,
      );
      emit(RecruiterScheduleInterviewSuccess(response));
    } catch (e) {
      emit(RecruiterScheduleInterviewFailed(e.toString()));
    }
  }
}