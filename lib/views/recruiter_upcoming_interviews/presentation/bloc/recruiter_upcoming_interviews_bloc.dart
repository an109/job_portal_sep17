import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/domain/usecases/recruiter_upcoming_interviews_usecase.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/presentation/bloc/recruiter_upcoming_interviews_event.dart';
import 'package:job_portal/views/recruiter_upcoming_interviews/presentation/bloc/recruiter_upcoming_interviews_state.dart';

class RecruiterUpcomingInterviewsBloc
    extends Bloc<RecruiterUpcomingInterviewsEvent, RecruiterUpcomingInterviewsState> {
  final RecruiterUpcomingInterviewsUseCase _useCase;

  RecruiterUpcomingInterviewsBloc(this._useCase) : super(RecruiterUpcomingInterviewsInitial()) {
    on<FetchUpcomingInterviews>(_onFetchUpcomingInterviews);
  }

  void _onFetchUpcomingInterviews(
      FetchUpcomingInterviews event,
      Emitter<RecruiterUpcomingInterviewsState> emit,
      ) async {
    emit(RecruiterUpcomingInterviewsLoading());
    try {
      final data = await _useCase.call();
      emit(RecruiterUpcomingInterviewsSuccess(data));
    } catch (e) {
      emit(RecruiterUpcomingInterviewsFailed(e.toString()));
    }
  }
}