import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/recruiter_send_assignment/presenation/bloc/recruiter_send_assignment_event.dart';
import 'package:job_portal/views/recruiter_send_assignment/presenation/bloc/recruiter_send_assignment_state.dart';

import '../../domain/usecases/recruiter_send_assignment_usecase.dart';

class RecruiterSendAssignmentBloc extends Bloc<RecruiterSendAssignmentEvent, RecruiterSendAssignmentState> {
  final RecruiterSendAssignmentUseCase _useCase;

  RecruiterSendAssignmentBloc(this._useCase) : super(RecruiterSendAssignmentInitial()) {
    on<SendAssignmentRequested>(_onSendAssignmentRequested);
  }

  void _onSendAssignmentRequested(
      SendAssignmentRequested event,
      Emitter<RecruiterSendAssignmentState> emit,
      ) async {
    emit(RecruiterSendAssignmentLoading());

    try {
      final response = await _useCase(
        applicantId: event.applicantId,
        entity: event.entity,
      );
      emit(RecruiterSendAssignmentSuccess(response));
    } catch (e) {
      emit(RecruiterSendAssignmentFailed(e.toString()));
    }
  }
}