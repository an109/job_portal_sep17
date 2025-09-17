import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/domain/usecases/recruiter_pipeline_candidates_usecase.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/presentation/bloc/recruiter_pipeline_candidates_event.dart';
import 'package:job_portal/views/recruiter_pipeline_candidates/presentation/bloc/recruiter_pipeline_candidates_state.dart';

class RecruiterPipelineCandidatesBloc
    extends Bloc<RecruiterPipelineCandidatesEvent, RecruiterPipelineCandidatesState> {
  final RecruiterPipelineCandidatesUseCase _useCase;

  RecruiterPipelineCandidatesBloc(this._useCase) : super(RecruiterPipelineCandidatesInitial()) {
    on<FetchPipelineCandidates>(_onFetchPipelineCandidates);
  }

  void _onFetchPipelineCandidates(
      FetchPipelineCandidates event,
      Emitter<RecruiterPipelineCandidatesState> emit,
      ) async {
    emit(RecruiterPipelineCandidatesLoading());
    try {
      final data = await _useCase.call();
      emit(RecruiterPipelineCandidatesSuccess(data));
    } catch (e) {
      emit(RecruiterPipelineCandidatesFailed(e.toString()));
    }
  }
}