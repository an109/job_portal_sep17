import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_pending_tasks/domain/usecases/recruiter_pending_tasks_usecase.dart';
import 'package:job_portal/views/recruiter_pending_tasks/presentation/bloc/recruiter_pending_tasks_event.dart';
import 'package:job_portal/views/recruiter_pending_tasks/presentation/bloc/recruiter_pending_tasks_state.dart';

class RecruiterPendingTasksBloc extends Bloc<RecruiterPendingTasksEvent, RecruiterPendingTasksState> {
  final RecruiterPendingTasksUseCase _useCase;

  RecruiterPendingTasksBloc(this._useCase) : super(RecruiterPendingTasksInitial()) {
    on<FetchPendingTasks>(_onFetchPendingTasks);
  }

  void _onFetchPendingTasks(
      FetchPendingTasks event,
      Emitter<RecruiterPendingTasksState> emit,
      ) async {
    emit(RecruiterPendingTasksLoading());
    try {
      final data = await _useCase.call();
      emit(RecruiterPendingTasksSuccess(data));
    } catch (e) {
      emit(RecruiterPendingTasksFailed(e.toString()));
    }
  }
}